const fs = require('fs');
const path = require('path');
const readline = require('readline');
const { parseGIF, decompressFrames } = require('gifuct-js');
const {
    openControlDevice,
    openLcdDevice,
    beginTransaction,
    applyTransaction,
    sendCommand,
    sleep,
} = require('./device');

const SCREEN_WIDTH = 240;
const SCREEN_HEIGHT = 135;
const BYTES_PER_PIXEL = 2;
const FRAME_SIZE = SCREEN_WIDTH * SCREEN_HEIGHT * BYTES_PER_PIXEL;
const HEADER_SIZE = 256;
const PAGE_SIZE = 4096;
const MAX_FRAMES = 60;
const LCD_ACK_TIMEOUT_MS = 300;

function rgb888ToRgb565(r, g, b) {
    return ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3);
}

function writeRgb565(buffer, offset, r, g, b) {
    const pixel = rgb888ToRgb565(r, g, b);
    buffer[offset] = pixel & 0xFF;
    buffer[offset + 1] = (pixel >> 8) & 0xFF;
}

function buildPaddedBuffer(header, frameData) {
    const totalSize = HEADER_SIZE + frameData.length;
    const pageCount = Math.ceil(totalSize / PAGE_SIZE);
    const paddedSize = pageCount * PAGE_SIZE;
    const buffer = Buffer.alloc(paddedSize, 0xFF);

    header.copy(buffer, 0, 0, HEADER_SIZE);
    frameData.copy(buffer, HEADER_SIZE);

    return buffer;
}

function frameDelayToKeyboard(delayCentiseconds) {
    let delay = Math.floor(delayCentiseconds / 2);
    if (delay < 1) delay = 1;
    if (delay > 255) delay = 255;
    return delay;
}

function applyFramePatch(canvas, frame) {
    const { left, top, width, height } = frame.dims;
    const patch = frame.patch;

    for (let y = 0; y < height; y++) {
        for (let x = 0; x < width; x++) {
            const patchIndex = (y * width + x) * 4;
            const alpha = patch[patchIndex + 3];
            if (alpha === 0) {
                continue;
            }

            const canvasX = left + x;
            const canvasY = top + y;
            if (canvasX >= SCREEN_WIDTH || canvasY >= SCREEN_HEIGHT) {
                continue;
            }

            const canvasIndex = (canvasY * SCREEN_WIDTH + canvasX) * 4;
            canvas[canvasIndex] = patch[patchIndex];
            canvas[canvasIndex + 1] = patch[patchIndex + 1];
            canvas[canvasIndex + 2] = patch[patchIndex + 2];
            canvas[canvasIndex + 3] = 255;
        }
    }
}

function clearCanvasRegion(canvas, left, top, width, height) {
    for (let y = top; y < top + height; y++) {
        for (let x = left; x < left + width; x++) {
            if (x >= SCREEN_WIDTH || y >= SCREEN_HEIGHT) {
                continue;
            }
            const index = (y * SCREEN_WIDTH + x) * 4;
            canvas[index] = 0;
            canvas[index + 1] = 0;
            canvas[index + 2] = 0;
            canvas[index + 3] = 255;
        }
    }
}

function canvasToRgb565Frame(canvas) {
    const frame = Buffer.alloc(FRAME_SIZE);
    let offset = 0;

    for (let y = 0; y < SCREEN_HEIGHT; y++) {
        for (let x = 0; x < SCREEN_WIDTH; x++) {
            const index = (y * SCREEN_WIDTH + x) * 4;
            writeRgb565(frame, offset, canvas[index], canvas[index + 1], canvas[index + 2]);
            offset += 2;
        }
    }

    return frame;
}

function gifToLcdBuffer(gifPath, { maxFrames = MAX_FRAMES, force = false } = {}) {
    const raw = fs.readFileSync(gifPath);
    const gif = parseGIF(raw.buffer.slice(raw.byteOffset, raw.byteOffset + raw.byteLength));
    const frames = decompressFrames(gif, true);

    if (frames.length === 0) {
        throw new Error('GIF contains no frames.');
    }

    let frameCount = frames.length;
    const originalFrameCount = frameCount;
    const warnings = [];

    if (frameCount > maxFrames && !force) {
        warnings.push(
            `GIF has ${originalFrameCount} frames; only the first ${maxFrames} will be used.`
        );
        frameCount = maxFrames;
    }
    if (frameCount > 255) {
        if (originalFrameCount > 255) {
            warnings.push(`GIF has ${originalFrameCount} frames; capped at 255 (header limit).`);
        }
        frameCount = 255;
    }

    for (const warning of warnings) {
        console.warn(`⚠️  ${warning}`);
    }

    const canvasWidth = gif.lsd.width;
    const canvasHeight = gif.lsd.height;
    if (canvasWidth !== SCREEN_WIDTH || canvasHeight !== SCREEN_HEIGHT) {
        console.warn(
            `⚠️  GIF is ${canvasWidth}x${canvasHeight}; keyboard expects ${SCREEN_WIDTH}x${SCREEN_HEIGHT}. ` +
            'Frames will be cropped/padded.'
        );
    }

    const header = Buffer.alloc(HEADER_SIZE, 0xFF);
    header[0] = frameCount;

    const frameBuffers = [];
    const canvas = Buffer.alloc(SCREEN_WIDTH * SCREEN_HEIGHT * 4, 0);
    for (let i = 0; i < canvas.length; i += 4) {
        canvas[i + 3] = 255;
    }

    for (let i = 0; i < frameCount; i++) {
        const frame = frames[i];
        applyFramePatch(canvas, frame);
        header[1 + i] = frameDelayToKeyboard(frame.delay ?? 10);
        frameBuffers.push(canvasToRgb565Frame(canvas));

        const disposal = frame.disposalType ?? 0;
        if (disposal === 2) {
            clearCanvasRegion(canvas, frame.dims.left, frame.dims.top, frame.dims.width, frame.dims.height);
        } else if (disposal === 3) {
            canvas.fill(0);
            for (let j = 0; j < canvas.length; j += 4) {
                canvas[j + 3] = 255;
            }
        }
    }

    const frameData = Buffer.concat(frameBuffers);
    const buffer = buildPaddedBuffer(header, frameData);
    validateLcdBuffer(buffer, { force, maxFrames });

    return {
        buffer,
        frameCount,
        originalFrameCount,
        warnings,
        source: gifPath,
        width: canvasWidth,
        height: canvasHeight,
    };
}

function loadBinBuffer(binPath) {
    const buffer = fs.readFileSync(binPath);
    if (!Buffer.isBuffer(buffer) || buffer.length === 0) {
        throw new Error('LCD image file is empty.');
    }
    return buffer;
}

function countFrames(buffer) {
    if (buffer.length < HEADER_SIZE) {
        throw new Error('LCD buffer is too small to contain a header.');
    }

    const headerFrameCount = buffer[0];
    const payloadBytes = buffer.length - HEADER_SIZE;
    const computedFrameCount = Math.floor(payloadBytes / FRAME_SIZE);

    return {
        headerFrameCount,
        computedFrameCount,
        pageCount: buffer.length / PAGE_SIZE,
    };
}

function validateLcdBuffer(buffer, { force = false, maxFrames = MAX_FRAMES } = {}) {
    if (buffer.length === 0) {
        throw new Error('LCD buffer is empty.');
    }
    if (buffer.length % PAGE_SIZE !== 0) {
        throw new Error(`LCD buffer size ${buffer.length} is not a multiple of ${PAGE_SIZE}.`);
    }

    const { headerFrameCount, computedFrameCount, pageCount } = countFrames(buffer);
    if (headerFrameCount === 0) {
        throw new Error('LCD buffer header reports 0 frames.');
    }
    if (headerFrameCount > maxFrames && !force) {
        throw new Error(
            `Buffer contains ${headerFrameCount} frames, which exceeds the safe limit of ${maxFrames}. ` +
            'Use --force to override (may corrupt keyboard menu graphics).'
        );
    }
    if (computedFrameCount < headerFrameCount) {
        throw new Error(
            `Buffer is truncated: header says ${headerFrameCount} frames but only ${computedFrameCount} fit.`
        );
    }

    const maxSafePages = Math.ceil((HEADER_SIZE + FRAME_SIZE * maxFrames) / PAGE_SIZE);
    if (pageCount > maxSafePages && !force) {
        throw new Error(
            `Buffer is ${pageCount} pages, exceeding the safe limit of ${maxSafePages} pages (~${maxFrames} frames). ` +
            'Use --force to override (may corrupt keyboard menu graphics).'
        );
    }

    return { headerFrameCount, computedFrameCount, pageCount };
}

function writeLcdPage(lcdDevice, page) {
    const report = Buffer.alloc(PAGE_SIZE + 1, 0x00);
    page.copy(report, 1);
    lcdDevice.write(report);
}

function readLcdAck(lcdDevice) {
    try {
        return lcdDevice.readTimeout(LCD_ACK_TIMEOUT_MS);
    } catch {
        return null;
    }
}

async function uploadLcdBuffer(buffer, {
    imageSlot = 1,
    onProgress,
    force = false,
    maxFrames = MAX_FRAMES,
} = {}) {
    const validation = validateLcdBuffer(buffer, { force, maxFrames });
    const pageCount = validation.pageCount;

    const controlDevice = openControlDevice();
    const lcdDevice = openLcdDevice();

    try {
        await beginTransaction(controlDevice);

        const header = Buffer.alloc(64, 0x00);
        header[0] = 0x04;
        header[1] = 0x72;
        header[2] = imageSlot;
        header[8] = pageCount & 0xFF;
        header[9] = (pageCount >> 8) & 0xFF;
        await sendCommand(controlDevice, header, true);

        for (let i = 0; i < pageCount; i++) {
            const start = i * PAGE_SIZE;
            const page = buffer.subarray(start, start + PAGE_SIZE);
            writeLcdPage(lcdDevice, page);
            readLcdAck(lcdDevice);
            await sleep(2);

            if (onProgress) {
                onProgress(i + 1, pageCount);
            }
        }

        await applyTransaction(controlDevice);
    } finally {
        controlDevice.close();
        lcdDevice.close();
    }

    return validation;
}

async function confirmUpload({ frameCount, pageCount, source, force }) {
    console.error('⚠️  WARNING: Uploading images to the LCD can permanently corrupt the');
    console.error("keyboard's built-in menu graphics if the frame limit is exceeded.");
    console.error('This damage is NOT recoverable by factory reset or firmware update.');
    console.error(`Source: ${source}`);
    console.error(`Frames: ${frameCount}, Pages: ${pageCount}${force ? ' (force enabled)' : ''}`);
    console.error('Continue? [y/N] ');

    const answer = await new Promise(resolve => {
        const rl = readline.createInterface({ input: process.stdin, output: process.stderr });
        rl.question('', response => {
            rl.close();
            resolve(response.trim().toLowerCase());
        });
    });

    if (answer !== 'y' && answer !== 'yes') {
        throw new Error('Upload aborted.');
    }
}

function resolveInputPath(inputPath) {
    const resolved = path.resolve(inputPath);
    if (!fs.existsSync(resolved)) {
        throw new Error(`File not found: ${resolved}`);
    }
    return resolved;
}

async function uploadLcdImage(inputPath, options = {}) {
    const resolved = resolveInputPath(inputPath);
    const ext = path.extname(resolved).toLowerCase();

    let buffer;
    let frameCount;
    if (ext === '.gif') {
        const converted = gifToLcdBuffer(resolved, options);
        buffer = converted.buffer;
        frameCount = converted.frameCount;
    } else if (ext === '.bin') {
        buffer = loadBinBuffer(resolved);
        frameCount = validateLcdBuffer(buffer, options).headerFrameCount;
    } else {
        throw new Error('Supported input formats: .gif or pre-built .bin');
    }

    if (!options.yes) {
        await confirmUpload({
            frameCount,
            pageCount: buffer.length / PAGE_SIZE,
            source: resolved,
            force: options.force,
        });
    }

    const validation = await uploadLcdBuffer(buffer, {
        imageSlot: options.slot ?? 1,
        force: options.force,
        onProgress: options.onProgress,
    });

    return {
        source: resolved,
        frameCount: validation.headerFrameCount,
        pageCount: validation.pageCount,
    };
}

function convertGifToBin(gifPath, outputPath, options = {}) {
    const { buffer, frameCount, width, height, warnings } = gifToLcdBuffer(gifPath, options);
    fs.writeFileSync(outputPath, buffer);
    return { outputPath, frameCount, width, height, bytes: buffer.length, pageCount: buffer.length / PAGE_SIZE, warnings };
}

module.exports = {
    SCREEN_WIDTH,
    SCREEN_HEIGHT,
    FRAME_SIZE,
    HEADER_SIZE,
    PAGE_SIZE,
    MAX_FRAMES,
    gifToLcdBuffer,
    loadBinBuffer,
    validateLcdBuffer,
    countFrames,
    uploadLcdBuffer,
    uploadLcdImage,
    convertGifToBin,
};
