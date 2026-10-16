/* Lunch Break! ending page bridge.
   Add <script defer src="ending-bridge.js"></script> after game.js in index.html.
   Works with the classic-script game.js used in the original VN.
   It does not alter game logic: it changes the *finished* button to open ending.html.
*/
(function () {
  'use strict';
  function atEnd() {
    return typeof finished !== 'undefined' && finished && typeof story !== 'undefined' && !!story;
  }
  function showEnding() {
    const vars = story.variablesState;
    const params = new URLSearchParams({
      health: String(vars.health ?? 50),
      fullness: String(vars.fullness ?? 30),
      money: String(vars.money ?? 20)
    });
    window.location.assign('ending.html?' + params.toString());
  }
  // Capture first, before game.js treats a finished run as a restart.
  document.addEventListener('click', function (event) {
    if (!atEnd() || !event.target.closest('#next')) return;
    event.preventDefault();
    event.stopImmediatePropagation();
    showEnding();
  }, true);
  document.addEventListener('keydown', function (event) {
    if (!atEnd() || !['Space','Enter'].includes(event.code)) return;
    if (['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement.tagName)) return;
    // On a focused button, the browser generates a click, handled above.
    if (document.activeElement.tagName === 'BUTTON') return;
    event.preventDefault();
    event.stopImmediatePropagation();
    showEnding();
  }, true);
  // Rename the old "Play again" prompt as soon as the last dialogue is shown.
  const next = document.getElementById('next');
  if (next) {
    const observer = new MutationObserver(function () {
      if (atEnd() && next.textContent !== 'See your ending →') {
        next.textContent = 'See your ending →';
        const note = document.getElementById('status');
        if (note) note.textContent = 'Your choices have led to a unique ending!';
      }
    });
    observer.observe(next,{childList:true,subtree:true});
  }
})();
