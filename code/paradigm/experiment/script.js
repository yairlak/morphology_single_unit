var subjectID = jsPsych.randomization.randomID(10);
var leftIsCorrect = Math.random() < 0.5;
var globalConsecutiveSuccesses = 0;
var globalScore = 0;
var globalNTrials = 0;

// shows informations if url ends with ?debug
var debug = false;
if (window.location.search == "?debug") {
  debug = true;
}

// Record the ID of the participant and some screen property just in case
jsPsych.data.addProperties({'ID': subjectID});
jsPsych.data.addProperties({'lang': lang});
jsPsych.data.addProperties({'leftIsCorrect': leftIsCorrect});
jsPsych.data.addProperties({'screenX': screen.width});
jsPsych.data.addProperties({'screenY': screen.height});
jsPsych.data.addProperties({'innerX': window.innerWidth});
jsPsych.data.addProperties({'innerY': window.innerHeight});

// declare the consent block.
var consent = {
  type:'external-html',
  url: "external-consent-"+lang+".html",
  cont_btn: "start"
};

// generate the instructions block. This depends on the `strings.js`file
var instructions = {
  type:'instructions',
  pages: gen_instructions(),
  show_clickable_nav: true,
  button_label_next: ">",
  button_label_previous: "<",
};

// transition from training to task
var transition_block = {
  type: 'html-keyboard-response',
  stimulus: '<p style="font-size: 3em">' + transition + "</p>",
  choices: jsPsych.NO_KEYS,
  trial_duration: 2000,
};


// Similarly the survey block is generated in the strings file to be
// multilingual. But during the survey the screen is presumably focused so we
// can estimate the FPS:
survey.on_start = function() {
  var err = calcFPS({count: 60, callback: function(fps) { FPS = (1000/round_fps(fps)) }});
}

// Generate the fullscreen screen depending on the lang
var fullscreen = gen_fullscreen(lang);

// The task is defined in the `materials.js` file
var timeline;
if (debug) {
  timeline = task;
} else {
  timeline = [consent, survey, instructions, fullscreen].concat(training);
  timeline.push(transition_block);
  timeline = timeline.concat(task);
  timeline.push(survey_posthoc);
}

// Uncomment when publishing
//sendData(subjectID, "experimentV1", "CTM", "ping");

jsPsych.init({
  timeline: timeline,
  show_progress_bar: false,
  show_preload_progress_bar: false,
  on_finish: finish_experiment
});
