// JS ↔ native bridge (see WebViewController.swift).
function sendToNative(message) {
  if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.native) {
    window.webkit.messageHandlers.native.postMessage(message);
  } else {
    log('not running inside the app: ' + JSON.stringify(message));
  }
}

// Called by native code through evaluateJavaScript.
window.onNativeMessage = function (payload) {
  log('native → js: ' + JSON.stringify(payload));
};

function log(line) {
  const el = document.getElementById('log');
  el.textContent += line + '\n';
}

document.getElementById('toast').addEventListener('click', function () {
  sendToNative({ action: 'toast', text: 'Hello from JavaScript' });
});
document.getElementById('device').addEventListener('click', function () {
  sendToNative({ action: 'deviceInfo' });
});
