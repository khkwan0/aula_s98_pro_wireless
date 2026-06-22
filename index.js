const {
    openControlDevice,
    beginTransaction,
    applyTransaction,
    finalizeTransaction,
    sendCommand,
    REPORT_SIZE,
} = require('./device');
const {
    uploadLcdImage,
    convertGifToBin,
    MAX_FRAMES,
    PAGE_SIZE,
} = require('./lcd');

const LIGHTING_MODES = {
    off: 0,
    static: 1,
    singleon: 2,
    singleoff: 3,
    glittering: 4,
    falling: 5,
    colourful: 6,
    colorful: 6,
    breath: 7,
    spectrum: 8,
    outward: 9,
    scrolling: 10,
    rolling: 11,
    rotating: 12,
    explode: 13,
    launch: 14,
    ripples: 15,
    flowing: 16,
    pulsating: 17,
    tilt: 18,
    shuttle: 19,
};

const MODE_NAMES = [
    'Off', 'Static', 'SingleOn', 'SingleOff', 'Glittering', 'Falling',
    'Colourful', 'Breath', 'Spectrum', 'Outward', 'Scrolling', 'Rolling',
    'Rotating', 'Explode', 'Launch', 'Ripples', 'Flowing', 'Pulsating',
    'Tilt', 'Shuttle',
];

function resolveMode(modeArg) {
    if (modeArg === undefined || modeArg === null) {
        throw new Error('Lighting mode is required.');
    }

    const asNumber = Number(modeArg);
    if (!Number.isNaN(asNumber) && asNumber >= 0 && asNumber <= 19) {
        return asNumber;
    }

    const mode = LIGHTING_MODES[String(modeArg).toLowerCase()];
    if (mode === undefined) {
        throw new Error(`Unknown mode "${modeArg}". Run "node index.js modes" to list options.`);
    }
    return mode;
}

async function lightingInit(device) {
    const payload = new Array(REPORT_SIZE).fill(0x00);
    payload[0] = 0x04;
    payload[1] = 0x13;
    payload[8] = 0x01;
    await sendCommand(device, payload, true);
}

async function setLighting({
    mode,
    r = 255,
    g = 255,
    b = 255,
    brightness = 5,
    speed = 3,
    direction = 0,
    colorful = false,
} = {}) {
    const modeId = resolveMode(mode);

    if (brightness < 0 || brightness > 5) {
        throw new Error('Brightness must be 0-5.');
    }
    if (speed < 0 || speed > 5) {
        throw new Error('Speed must be 0-5.');
    }

    const device = openControlDevice();

    try {
        await beginTransaction(device);
        await lightingInit(device);

        const payload = new Array(REPORT_SIZE).fill(0x00);
        payload[0] = modeId;

        if (modeId !== 0) {
            payload[1] = r;
            payload[2] = g;
            payload[3] = b;
            payload[8] = colorful ? 1 : 0;
            payload[9] = brightness;
            payload[10] = speed;
            payload[11] = direction;
        }

        payload[14] = 0x55;
        payload[15] = 0xAA;
        await sendCommand(device, payload, false);

        await applyTransaction(device);
        await finalizeTransaction(device);

        const modeName = MODE_NAMES[modeId];
        if (modeId === 0) {
            console.log('💡 Backlight turned off.');
        } else if (colorful) {
            console.log(`💡 Set ${modeName} (rainbow) — brightness ${brightness}, speed ${speed}.`);
        } else {
            console.log(`💡 Set ${modeName} to rgb(${r}, ${g}, ${b}) — brightness ${brightness}, speed ${speed}.`);
        }
    } finally {
        device.close();
    }
}

async function syncKeyboardTime(when = new Date()) {
    const targetTime = when instanceof Date ? when : new Date(when);
    if (Number.isNaN(targetTime.getTime())) {
        throw new Error('Invalid date/time.');
    }

    const device = openControlDevice();

    try {
        await beginTransaction(device);

        const initPayload = new Array(REPORT_SIZE).fill(0x00);
        initPayload[0] = 0x04;
        initPayload[1] = 0x28;
        initPayload[8] = 0x01;
        await sendCommand(device, initPayload, true);

        const dataPayload = new Array(REPORT_SIZE).fill(0x00);
        dataPayload[0] = 0x00;
        dataPayload[1] = 0x01;
        dataPayload[2] = 0x5A;
        dataPayload[3] = targetTime.getFullYear() % 2000;
        dataPayload[4] = targetTime.getMonth() + 1;
        dataPayload[5] = targetTime.getDate();
        dataPayload[6] = targetTime.getHours();
        dataPayload[7] = targetTime.getMinutes();
        dataPayload[8] = targetTime.getSeconds();
        dataPayload[10] = targetTime.getDay();
        dataPayload[62] = 0x55;
        dataPayload[63] = 0xAA;
        await sendCommand(device, dataPayload, true);

        await applyTransaction(device);
        console.log(`⚡ Synced clock to ${targetTime.toLocaleString()} — check the keyboard screen.`);
    } finally {
        device.close();
    }
}

function printModes() {
    console.log('Lighting modes (0-19 or name):');
    MODE_NAMES.forEach((name, id) => {
        console.log(`  ${String(id).padStart(2)}  ${name}`);
    });
    console.log('\nExamples:');
    console.log('  node index.js light static 5 0 255 0 0');
    console.log('  node index.js light breath 5 3 0 0 255');
    console.log('  node index.js light spectrum');
    console.log('  node index.js light rolling 5 3 colorful -d 1');
    console.log('  node index.js off');
}

function printUsage() {
    console.log(`Usage:
  node index.js clock [datetime]
  node index.js light <mode> [brightness] [speed] [r g b | colorful] [-d direction]
  node index.js lcd upload <file.gif|.bin> [--yes] [--force] [--slot N]
  node index.js lcd convert <file.gif> [--output out.bin] [--force]
  node index.js off
  node index.js modes

Commands:
  clock   Sync keyboard LCD clock (defaults to system time)
  light   Set backlight effect (mode 0-19 or name)
  lcd     Convert or upload LCD animations (max ${MAX_FRAMES} frames unless --force)
  off     Turn backlight off
  modes   List available lighting modes

Clock examples:
  node index.js clock
  node index.js clock 2026-12-25 09:00:00
  node index.js clock --at 2026-12-25T09:00:00

LCD examples:
  node index.js lcd convert animation.gif --output animation.bin
  node index.js lcd upload animation.gif --yes
  node index.js lcd upload animation.bin`);
}

function parseClockArgs(args) {
    if (args.length === 0) {
        return new Date();
    }

    const atIndex = args.indexOf('--at');
    const dateString = atIndex !== -1
        ? args.slice(atIndex + 1).join(' ')
        : args.join(' ');

    if (!dateString) {
        throw new Error('Missing value for --at.');
    }

    const targetTime = new Date(dateString);
    if (Number.isNaN(targetTime.getTime())) {
        throw new Error(`Invalid date/time: "${dateString}"`);
    }

    return targetTime;
}

function parseLightArgs(args) {
    const directionIndex = args.indexOf('-d');
    let direction = 0;
    if (directionIndex !== -1) {
        direction = Number(args[directionIndex + 1] ?? 0);
        args = args.filter((_, i) => i !== directionIndex && i !== directionIndex + 1);
    }

    const mode = args[0];
    const brightness = args[1] !== undefined ? Number(args[1]) : 5;
    const speed = args[2] !== undefined ? Number(args[2]) : 3;

    if (args.includes('colorful') || args.includes('colourful')) {
        return { mode, brightness, speed, direction, colorful: true };
    }

    const colorStart = args.length >= 6 ? 3 : args.length >= 5 ? 2 : -1;
    if (colorStart !== -1 && args.length >= colorStart + 3) {
        return {
            mode,
            brightness,
            speed,
            direction,
            r: Number(args[colorStart]),
            g: Number(args[colorStart + 1]),
            b: Number(args[colorStart + 2]),
        };
    }

    return { mode, brightness, speed, direction };
}

function takeFlag(args, flag) {
    const index = args.indexOf(flag);
    if (index === -1) {
        return { value: undefined, args };
    }
    return {
        value: args[index + 1],
        args: args.filter((_, i) => i !== index && i !== index + 1),
    };
}

function hasFlag(args, flag) {
    return args.includes(flag);
}

function parseLcdUploadArgs(args) {
    const force = hasFlag(args, '--force');
    const yes = hasFlag(args, '--yes');
    let slot = 1;

    const slotFlag = takeFlag(args, '--slot');
    args = slotFlag.args;
    if (slotFlag.value !== undefined) {
        slot = Number(slotFlag.value);
        if (Number.isNaN(slot) || slot < 1 || slot > 255) {
            throw new Error('--slot must be a number between 1 and 255.');
        }
    }

    args = args.filter(arg => arg !== '--force' && arg !== '--yes');
    const inputPath = args[0];
    if (!inputPath) {
        throw new Error('Missing input file. Usage: node index.js lcd upload <file.gif|.bin>');
    }

    return { inputPath, force, yes, slot };
}

function parseLcdConvertArgs(args) {
    const force = hasFlag(args, '--force');
    let outputPath;

    const outputFlag = takeFlag(args, '--output');
    args = outputFlag.args;
    if (outputFlag.value) {
        outputPath = outputFlag.value;
    }

    const altOutputFlag = takeFlag(args, '-o');
    args = altOutputFlag.args;
    if (altOutputFlag.value) {
        outputPath = altOutputFlag.value;
    }

    args = args.filter(arg => arg !== '--force');
    const inputPath = args[0];
    if (!inputPath) {
        throw new Error('Missing input GIF. Usage: node index.js lcd convert <file.gif> [--output out.bin]');
    }

    if (!outputPath) {
        outputPath = inputPath.replace(/\.gif$/i, '') + '.bin';
    }

    return { inputPath, outputPath, force };
}

async function main() {
    const argv = process.argv.slice(2);
    const command = argv[0];
    const rest = argv.slice(1);

    try {
        if (!command || command === 'help' || command === '--help' || command === '-h') {
            printUsage();
            return;
        }

        if (command === 'clock' || command === 'time') {
            await syncKeyboardTime(parseClockArgs(rest));
            return;
        }

        if (command === 'modes') {
            printModes();
            return;
        }

        if (command === 'off') {
            await setLighting({ mode: 0 });
            return;
        }

        if (command === 'light' || command === 'rgb') {
            await setLighting(parseLightArgs(rest));
            return;
        }

        if (command === 'lcd') {
            const subcommand = rest[0];
            const lcdArgs = rest.slice(1);

            if (subcommand === 'upload') {
                const options = parseLcdUploadArgs(lcdArgs);
                const result = await uploadLcdImage(options.inputPath, {
                    force: options.force,
                    yes: options.yes,
                    slot: options.slot,
                    onProgress: (sent, total) => {
                        process.stdout.write(`\r📤 Uploading page ${sent}/${total}`);
                    },
                });
                process.stdout.write('\n');
                console.log(
                    `🖼️  Uploaded ${result.source} (${result.frameCount} frames, ${result.pageCount} pages).`
                );
                return;
            }

            if (subcommand === 'convert') {
                const options = parseLcdConvertArgs(lcdArgs);
                const result = convertGifToBin(options.inputPath, options.outputPath, {
                    force: options.force,
                });
                console.log(
                    `🧩 Converted ${options.inputPath} -> ${result.outputPath} ` +
                    `(${result.frameCount} frames, ${result.pageCount} pages, ${result.bytes} bytes).`
                );
                return;
            }

            throw new Error('Unknown lcd subcommand. Use "upload" or "convert".');
        }

        printUsage();
        process.exitCode = 1;
    } catch (error) {
        console.error(`❌ ${error.message}`);
        console.error('👉 Tip: Make sure no other control software (like AULA utility) is open.');
        process.exitCode = 1;
    }
}

if (require.main === module) {
    main();
}

module.exports = {
    setLighting,
    syncKeyboardTime,
    uploadLcdImage,
    convertGifToBin,
    LIGHTING_MODES,
    MODE_NAMES,
    MAX_FRAMES,
    PAGE_SIZE,
};
