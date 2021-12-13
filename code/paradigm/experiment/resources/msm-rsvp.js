jsPsych.plugins["rsvp"] = (function() {

  var plugin = {};

  plugin.info = {
    name: 'rsvp',
    description: '',
    parameters: {
      sentence: {
        type: jsPsych.plugins.parameterType.HTML_STRING,
        pretty_name: 'Sentence',
        default: undefined,
        description: 'The sentence to flash, word per word'
      },
      choices: {
        type: jsPsych.plugins.parameterType.KEY,
        array: true,
        pretty_name: 'Choices',
        default: jsPsych.ALL_KEYS,
        description: 'The keys the subject is allowed to press to respond to the stimulus.'
      },
      presentation_time: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Presentation Time',
        default: null,
        description: "Each word's presentation time"
      },
      inter_word_time: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Inter Words Time',
        default: null,
        description: "Duration between two words"
      },
      correct: {
        type: jsPsych.plugins.parameterType.BOOL,
        pretty_name: 'Correct',
        default: null,
        description: "Whether the trial should elicit a 'correct' or 'incorrect' response"
      },
    }
  }

  plugin.trial = function(display_element, trial) {

    var words = trial.sentence.split(" ");
    var last_word_idx = 0;
    var clock_start = null;
    var keyboardListener;
    var lastrAF;
    var hasSeenLastWord = false;
    var centered_grid = document.createElement("div");
    var content = document.createElement("p");
    var div_left = document.createElement("div");
    var div_right = document.createElement("div");
    centered_grid.id = "grid_wrapper";
    content.id = "rsvp";
    content.innerHTML = "+";
    centered_grid.appendChild(div_left);
    centered_grid.appendChild(content);
    centered_grid.appendChild(div_right);
    display_element.appendChild(centered_grid);

    // What to do whenever a key is pressed?
    var end_trial = function(info) {
      // kill any remaining setTimeout/keyboards handlers
      jsPsych.pluginAPI.clearAllTimeouts();
      if (typeof keyboardListener !== 'undefined') {
        jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);
      }

      window.cancelAnimationFrame(lastrAF);

      // gather the data to store for the trial
      trial.rt = info.rt
      trial.response = info.key

      // clear the display and send the data back
      var hasAnsweredCorrectly = false;
      if (trial.correct) {
        if (leftIsCorrect) {
          if (jsPsych.pluginAPI.compareKeys("leftarrow", info.key)) {
            hasAnsweredCorrectly = true;
          }
        } else {
          if (jsPsych.pluginAPI.compareKeys("rightarrow", info.key)) {
            hasAnsweredCorrectly = true;
          }
        }
      } else {
        if (leftIsCorrect) {
          if (jsPsych.pluginAPI.compareKeys("rightarrow", info.key)) {
            hasAnsweredCorrectly = true;
          }
        } else {
          if (jsPsych.pluginAPI.compareKeys("leftarrow", info.key)) {
            hasAnsweredCorrectly = true;
          }
        }
      }

      // If it's a critical trial and the subject hasn't seen the last word,
      // then he is wrong by construction.
      if ((trial.filler === "no") && (!hasSeenLastWord) && (!trial.training)) {
        hasAnsweredCorrectly = false;
      }

      trial.hasAnsweredCorrectly = hasAnsweredCorrectly;
      trial.hasSeenLastWord = hasSeenLastWord;
      content.innerHTML = "+";
      if (!trial.training) {
        globalNTrials += 1;
      }
      if (hasAnsweredCorrectly) {
        correct[globalConsecutiveSuccesses].play();
        if (!trial.training) {
          globalScore += 1;
        }
        globalConsecutiveSuccesses = Math.min(globalConsecutiveSuccesses + 1, 6);
        content.style.color = "#1b9d00";
      } else {
        globalConsecutiveSuccesses = 0;
        incorrect.play();
        content.style.color = "#fb3e3e";
      }

      // Remove hard-to-read fields
      setTimeout(function() {
        display_element.innerHTML = '';
        jsPsych.finishTrial(trial);
      }, 500);
    };

    // Define the two alternating functions
    function step_word(timestamp) {
      var progress;

      // Is this the first time we enter this loop?
      if (clock_start === null) {
        clock_start = timestamp;
        content.style.color = "#FFFFFF"; 
        content.innerHTML = words[last_word_idx];
        last_word_idx += 1;
        if (typeof keyboardListener === 'undefined') {
          // Attach the "end_trial" function to the appropriate keys
          keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
            callback_function: end_trial,
            valid_responses: trial.choices,
            rt_method: 'performance'
          });
        }
        if ((!hasSeenLastWord) && (last_word_idx == words.length)) {
          hasSeenLastWord = true;
          jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);
            keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
              callback_function: end_trial,
              valid_responses: trial.choices,
              rt_method: 'performance'
            });
        }
      }
      progress = timestamp - clock_start;

      // Should we switch? Remove half a framerate for max accuracy
      if (progress < trial.presentation_time - (FPS/2)) {
        lastrAF = requestAnimationFrame(step_word);
      } else {
        clock_start = null;
        lastrAF = requestAnimationFrame(step_cross);
      }
    }

    function step_cross(timestamp) {
      var progress;
      // Is this the first time we enter this loop?
      if (clock_start === null) {
        clock_start = timestamp;
        content.innerHTML = "+";
        // Add helpful side boxes
        if (last_word_idx >= words.length) {
          div_left.innerHTML = "<p>" + (leftIsCorrect ? correct_str : incorrect_str) + "</p>";
          // Debug:
          //div_left.innerHTML += "<p>" + trial.sentence + " correct=" +trial.correct + "</p>"
          div_right.innerHTML = "<p>" + (leftIsCorrect ? incorrect_str : correct_str) + "</p>";
          div_left.classList.add("keyhint");
          div_right.classList.add("keyhint");
          div_left.style.marginRight = "0";
          div_right.style.marginLeft = "0";
        }
      }
      progress = timestamp - clock_start;

      if (progress < trial.inter_word_time - (FPS/2) || last_word_idx >= words.length) {
        lastrAF = requestAnimationFrame(step_cross);
      } else {
        clock_start = null;
        lastrAF = requestAnimationFrame(step_word);
      }
    }

    setTimeout(function() { lastrAF = requestAnimationFrame(step_word);}, 500);

  };

  return plugin;
})();
