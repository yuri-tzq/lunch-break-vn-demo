// Ink controls story, variables and choices. Browser code controls visuals.
// You can replace these demo SVG paths with YOUR OWN transparent PNG files.
const $ = (id) => document.getElementById(id);

const backgroundFiles = {
  room:       { file: 'assets/backgrounds/room.jpg',       label: 'BEDROOM' },
  bus_stop:   { file: 'assets/backgrounds/bus_stop.png',   label: 'BUS STOP' },
  campus:     { file: 'assets/backgrounds/campus.jpg',     label: 'CAMPUS' },
  class:      { file: 'assets/backgrounds/class.jpg',      label: 'CLASS' },
  fastfood:   { file: 'assets/backgrounds/fastfood.png',   label: 'FAST-FOOD RESTAURANT' },
  foodcourt:  { file: 'assets/backgrounds/foodcourt.jpg',  label: 'LUNCH BREAK' },
  park:       { file: 'assets/backgrounds/park.svg',       label: 'SCHOOL GARDEN' },
  street:     { file: 'assets/backgrounds/street.jpg',     label: 'STREET' },

};

// Add or edit names here when you put your own images in assets/sprites/.
// Names on the left match Inky # tags exactly (without the #).
const spriteFiles = {
  rui_normal:    'assets/sprites/rui_normal.png',
  rui_speak:     'assets/sprites/rui_speak.png',
  rui_smug:     'assets/sprites/rui_smug.png',
  rui_shock:     'assets/sprites/rui_shock.png',
  rui_smile:     'assets/sprites/rui_smile.png',
  honami_normal: 'assets/sprites/honami_normal.png',
  honami_happy:  'assets/sprites/honami_happy.png',
  honami_listening: 'assets/sprites/honami_listening.png',
  honami_smile:  'assets/sprites/honami_smile.png',
  honami_shock:  'assets/sprites/honami_shock.png',
};

let source = null;
let story = null;
let finished = false;

// The speaker labels in Ink are mapped to the beginning of sprite filenames.
// Add more names/aliases here as you introduce new characters.
const speakerSpritePrefixes = {
  rui: 'rui_',
  'kamishiro rui': 'rui_',
  '神代類': 'rui_',
  honami: 'honami_',
  'mochizuki honami': 'honami_',
  '望月穂波': 'honami_',
  '望月穗波': 'honami_',
  '穂波': 'honami_',
  '穗波': 'honami_',
  momo: 'momo_'
};

// Brighten only the current speaker; dim the other character when BOTH
// characters are on screen. Narrator/You/unknown labels leave both bright.
function updateSpeakerFocus(speakerName) {
  const prefix = speakerSpritePrefixes[(speakerName || '').trim().toLowerCase()];
  const sprites = [$('sprite-left'), $('sprite-right')];
  const visible = sprites.filter(sprite =>
    sprite.classList.contains('is-visible') && Boolean(sprite.dataset.sprite)
  );
  const activeOnStage = Boolean(prefix && visible.some(sprite =>
    sprite.dataset.sprite.startsWith(prefix)
  ));

  for (const sprite of sprites) {
    const shouldDim = activeOnStage &&
      sprite.classList.contains('is-visible') &&
      !sprite.dataset.sprite.startsWith(prefix);
    sprite.classList.toggle('is-dimmed', shouldDim);
  }
}

function showError(message) {
  $('speaker').textContent = 'SETUP';
  $('dialogue').textContent = message;
  $('status').textContent = 'See README.md for setup instructions.';
  $('next').hidden = true;
}

// Read the current Ink stats and display both values and short descriptions.
// Health is a game score (not a real-world medical measurement).
function updateStats() {
  if (!story) return;

  const values = {};
  for (const key of ['health', 'money', 'fullness']) {
    const value = story.variablesState[key];
    const numeric = value === undefined || value === null ? NaN : Number(value);
    values[key] = Number.isFinite(numeric) ? numeric : null;

    const output = $(key);
    if (output) output.textContent = values[key] === null ? '—' : String(value);
  }

  const { health, money, fullness } = values;
  const descriptions = {
    'health-status': health === null ? 'Not tracked' :
      health >= 75 ? 'Healthy!' :
      health >= 50 ? 'Doing okay' :
      health >= 25 ? 'Needs more balance' :
      'Time to eat healthier!',

    'money-status': money === null ? 'Not tracked' :
      money >= 30 ? 'Plenty!' :
      money >= 15 ? 'Still acceptable' :
      money > 0 ? 'Running low' :
      "Broke",

    'fullness-status': fullness === null ? 'Not tracked' :
      fullness >= 86 ? 'Overfull!' :
      fullness >= 61 ? 'Comfortably full' :
      fullness >= 31 ? 'A little hungry' :
      'Starving!'
  };

  for (const [id, description] of Object.entries(descriptions)) {
    const output = $(id);
    if (output) output.textContent = description;
  }

  // Keep the meters between 0% and 100% even if an Ink variable exceeds 100.
  for (const key of ['health', 'fullness']) {
    const value = values[key];
    const bar = $(`${key}-bar`);
    const meter = $(`${key}-meter`);
    const percentage = value === null ? 0 : Math.min(100, Math.max(0, value));
    if (bar) bar.style.width = `${percentage}%`;
    if (meter) {
      meter.setAttribute('aria-valuenow', String(percentage));
      meter.setAttribute('aria-valuetext', descriptions[`${key}-status`]);
      meter.classList.toggle('is-unavailable', value === null);
      meter.classList.toggle('is-overfull', key === 'fullness' && value !== null && value >= 86);
      meter.classList.toggle('is-low', key === 'health' && value !== null && value < 25);
    }
  }
}

function updateSpriteLayout() {
  const left = $('sprite-left');
  const right = $('sprite-right');
  const count = Number(left.dataset.sprite !== undefined && left.dataset.sprite !== '') +
                Number(right.dataset.sprite !== undefined && right.dataset.sprite !== '');
  $('stage').dataset.visibleCount = String(count);
}

function setSprite(side, name) {
  const element = $(side === 'left' ? 'sprite-left' : 'sprite-right');
  if (name === 'none') {
    element.dataset.sprite = '';
    element.classList.remove('is-visible');
    element.setAttribute('aria-hidden', 'true');
    element.removeAttribute('src');
    updateSpriteLayout();
    updateSpeakerFocus($('speaker').textContent);
    return;
  }
  if (!Object.prototype.hasOwnProperty.call(spriteFiles, name)) {
    console.warn(`Unknown sprite '${name}'. Add it to spriteFiles in game.js.`);
    return;
  }
  element.dataset.sprite = name;
  element.src = spriteFiles[name];
  element.alt = `${name.replaceAll('_', ' ')} (${side})`;
  element.classList.add('is-visible');
  element.setAttribute('aria-hidden', 'false');
  updateSpriteLayout();
  updateSpeakerFocus($('speaker').textContent);
}

function clearSprites() {
  setSprite('left', 'none');
  setSprite('right', 'none');
}

function applyTags(tags) {
  // Examples:
  //   # sprite:rui_normal                  -> one centered sprite (legacy)
  //   # left:rui_normal # right:honami_normal -> two sprites
  //   # left:none                         -> remove just left
  //   # right:none                        -> remove just right
  //   # sprite:none                       -> remove both
  for (const rawTag of tags ?? []) {
    const colon = rawTag.indexOf(':');
    if (colon < 0) continue;
    const key = rawTag.slice(0, colon).trim().toLowerCase();
    const value = rawTag.slice(colon + 1).trim().toLowerCase();
    if (key === 'bg') {
      const background = backgroundFiles[value];
      if (background) {
        $('background').src = background.file;
        $('location').textContent = background.label;
      } else {
        console.warn(`Unknown background '${value}'. Add it to backgroundFiles.`);
      }
    } else if (key === 'left' || key === 'right') {
      setSprite(key, value);
    } else if (key === 'sprite') {
      // Backwards compatibility for the earlier single-sprite game:
      // a named sprite alone is centered automatically.
      if (value === 'none') {
        clearSprites();
      } else if (Object.prototype.hasOwnProperty.call(spriteFiles, value)) {
        setSprite('right', 'none');
        setSprite('left', value);
      } else {
        console.warn(`Unknown sprite '${value}'. Add it to spriteFiles.`);
      }
    }
  }
}


function displayDialogue(line) {
  const match = line.match(/^([^:]{1,35}):\s*(.*)$/s);
  const speakerName = match ? match[1].trim() : 'Narrator';

  $('speaker').textContent = speakerName;

  const dialogueText = match ? match[2] : line;
  $('dialogue').textContent = dialogueText.replaceAll('[NL]', '\n');

  updateSpeakerFocus(speakerName);
}


function displayChoices() {
  const choices = $('choices');
  choices.replaceChildren();
  for (const choice of story.currentChoices) {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'choice';
    button.textContent = choice.text;
    button.addEventListener('click', () => {
      story.ChooseChoiceIndex(choice.index);
      choices.replaceChildren();
      updateStats();
      advance();
    });
    choices.append(button);
  }
}

function advance() {
  if (!story) return;
  if (finished) { restart(); return; }

  for (let n = 0; n < 100 && story.canContinue; n++) {
    const line = story.Continue().trim();
    applyTags(story.currentTags);
    updateStats();
    if (!line) continue;
    displayDialogue(line);
    break;
  }

  displayChoices();
  const hasChoices = story.currentChoices.length > 0;
  const canContinue = story.canContinue;
  if (!canContinue && !hasChoices) {
    finished = true;
    $('next').textContent = 'Play again ↻';
    $('status').textContent = 'The story has ended. You can restart.';
    $('next').hidden = false;
  } else {
    $('next').textContent = 'Next →';
    $('next').hidden = hasChoices && !canContinue;
    $('status').textContent = hasChoices && !canContinue ? 'Choose an option to continue.' : 'Your decisions affect story variables.';
  }
}

function restart() {
  if (!source || !window.inkjs?.Story) return;
  story = new window.inkjs.Story(source);
  finished = false;
  $('choices').replaceChildren();
  $('next').hidden = false;
  $('background').src = backgroundFiles.campus.file;
  $('location').textContent = backgroundFiles.campus.label;
  clearSprites(); // No leftover sprites after restarting!
  updateStats();
  advance();
}

async function initialize() {
  $('next').addEventListener('click', advance);
  $('restart').addEventListener('click', restart);
  document.addEventListener('keydown', (event) => {
    if ((event.code === 'Space' || event.code === 'Enter') &&
        !['BUTTON', 'INPUT', 'TEXTAREA'].includes(document.activeElement.tagName) &&
        story && !$('next').hidden) {
      event.preventDefault();
      advance();
    }
  });

  if (!window.inkjs?.Story) {
    showError('Cannot load inkjs. Check your internet connection, or install a local copy of inkjs.');
    return;
  }
  try {
    const response = await fetch('./story.json', { cache: 'no-store' });
    if (!response.ok) throw new Error('story.json not found');
    source = await response.text();
    restart();
  } catch (error) {
    console.error('Ink setup failed:', error);
    showError('Export your story.ink from Inky as story.json, then open via VS Code Live Server.');
  }
}

initialize();
