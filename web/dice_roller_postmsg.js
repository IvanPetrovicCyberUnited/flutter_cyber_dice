// Add this script to your dice_roller.html for postMessage support
window.addEventListener('message', function(event) {
  if (event.data && event.data.action === 'throwDice') {
    if (typeof window.throwDice === 'function') {
      window.throwDice(event.data.diceCount);
    }
  }
});
