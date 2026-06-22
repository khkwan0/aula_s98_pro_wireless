const HID = require('node-hid');

const VENDOR_ID = 0x0C45;
const PRODUCT_ID = 32778; // 0x800A
const CONTROL_USAGE_PAGE = 65299; // 0xFF13
const LCD_USAGE_PAGE = 65384; // 0xFF68
const REPORT_SIZE = 64;
const CMD_DELAY_MS = 35;

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function toFeatureReport(payload) {
    const report = new Array(REPORT_SIZE + 1).fill(0x00);
    for (let i = 0; i < payload.length && i < REPORT_SIZE; i++) {
        report[i + 1] = payload[i];
    }
    return report;
}

async function sendCommand(device, payload, readback) {
    device.sendFeatureReport(toFeatureReport(payload));
    await sleep(CMD_DELAY_MS);

    if (readback) {
        device.getFeatureReport(0, REPORT_SIZE + 1);
        await sleep(CMD_DELAY_MS);
    }
}

function findControlDevice() {
    return HID.devices().find(d =>
        d.vendorId === VENDOR_ID &&
        d.productId === PRODUCT_ID &&
        d.usagePage === CONTROL_USAGE_PAGE
    );
}

function findLcdDevice() {
    return HID.devices().find(d =>
        d.vendorId === VENDOR_ID &&
        d.productId === PRODUCT_ID &&
        d.usagePage === LCD_USAGE_PAGE &&
        d.interface === 2
    );
}

function getDeviceName() {
    const device =
        findControlDevice() ||
        findLcdDevice() ||
        HID.devices().find(
            d => d.vendorId === VENDOR_ID && d.productId === PRODUCT_ID
        );
    return device?.product || 'AULA keyboard';
}

function openControlDevice() {
    const targetDevice = findControlDevice();
    if (!targetDevice) {
        throw new Error(`${getDeviceName()} not found. Ensure it is connected via USB-C cable.`);
    }
    console.log(`🔗 Found device: ${targetDevice.product} on path: ${targetDevice.path}`);
    return new HID.HID(targetDevice.path);
}

function openLcdDevice() {
    const targetDevice = findLcdDevice();
    if (!targetDevice) {
        throw new Error(`${getDeviceName()} LCD interface not found. Ensure the keyboard is connected via USB-C cable.`);
    }
    return new HID.HID(targetDevice.path);
}

async function beginTransaction(device) {
    await sendCommand(device, [0x04, 0x18], true);
}

async function applyTransaction(device) {
    await sendCommand(device, [0x04, 0x02], true);
}

async function finalizeTransaction(device) {
    await sendCommand(device, [0x04, 0xF0], false);
}

module.exports = {
    VENDOR_ID,
    PRODUCT_ID,
    REPORT_SIZE,
    CMD_DELAY_MS,
    sleep,
    sendCommand,
    findControlDevice,
    findLcdDevice,
    getDeviceName,
    openControlDevice,
    openLcdDevice,
    beginTransaction,
    applyTransaction,
    finalizeTransaction,
};
