var lang = "en";
// Switch the language depending on the URL with fallback on "en"
if (window.location.search == "?fr") {
  lang = "fr";
} else if (window.location.search == "?en") {
  lang = "en";
}

var survey;
if (lang == "en") {
  var survey = { type: "survey-dropdown",
    preamble: "A little questionnaire to start with:",
    questions: [
      { prompt: "Are you a native speaker of English (spoken at home before the age of 7)?",
        options: ["Yes", "No"],
        labels: ["native", "non-native"]
      },
      {
        prompt: "Gender:",
        options: [
          "Man",
          "Woman",
          "Non-binary",
          "Other",
          "Prefer not to answer",
        ],
        labels: ["M", "F", "NB", "O", "NoAnswer"],
      },
      { prompt: "Age:", htmlType: "number" },
      {
        prompt: "Highest degree obtained:",
        options: [
          "Primary school",
          "Middle school",
          "High School",
          "Bachelor",
          "Master",
          "PhD",
        ],
        labels: [
          "PrimarySchool",
          "MiddleSchool",
          "HighSchool",
          "Ba",
          "Ms",
          "PhD",
        ],
      },
      { prompt: "Are you a native speaker of other languages? If yes, list them, separated by commas", htmlType: "text",  required: false},
      {
        prompt: "How 'calm' do you estimate your environment for the duration of the experiment, on a scale from 1 (least calm) to 10 (most calm) ?",
        htmlType: "likert",
      },
    ],
    button_label: "Continue",
  };
} else if (lang == "fr") {
  var survey = {
    type: "survey-dropdown",
    preamble: "Un petit questionnaire pour commencer",
    questions: [
      { prompt: "Êtes vous un locuteur natif du français ? (Langue parlée à la maison avant l'âge de 7 ans)",
        options: ["Oui", "Non"],
        labels: ["native", "non-native"]
      },
      {
        prompt: "Genre",
        options: [
          "Homme",
          "Femme",
          "Non binaire",
          "Autre",
          "Préfère ne pas répondre",
        ],
        labels: ["M", "F", "NB", "O", "NoAnswer"],
      },
      { prompt: "Age", htmlType: "number" },
      {
        prompt: "Plus haut niveau de scolarité atteint",
        options: [
          "Ecole primaire",
          "Collège",
          "Lycée",
          "Licence",
          "Master",
          "Doctorat",
        ],
        labels: [
          "PrimarySchool",
          "MiddleSchool",
          "HighSchool",
          "Ba",
          "Ms",
          "PhD",
        ],
      }
    ],
    button_label: "Continuer",
  };
}

var survey_posthoc;
if (lang == "en") {
  survey_posthoc = {
    type: "survey-dropdown",
    preamble: "<h2>Feedback</h2>Thank you so much for participating. We would appreciate if you could answer a few additional questions about the experiment.",
    questions: [
      { prompt: "Did you have a strategy to do the task without <strong>reading the full sentence?</strong>",
        options: ["Yes", "No"],
        labels: ["has-strategy-to-skip", "no-strategy-to-strategy"],
        required: false,
      },
      { prompt: "If you answered yes to the last question, can you please very briefly describe it in this field?", htmlType: "text",  required: false},
      { prompt: "Did you feel like the sentences were weird? (1: very natural, 10: very weird)",
        htmlType: "likert",
        required: false,
      },
      { prompt: "Did you find the task hard? (1: very easy, 10: very hard)",
        htmlType: "likert",
        required: false,
      },
    ],
    button_label: "Continue",
  };
} else if (lang == "fr") {
  survey_posthoc = {
    type: "survey-dropdown",
    preamble: "<h2>Feedback</h2>Merci pour votre participation. Nou aimerions vous poser encore quelques questions, facultatives, sur l'expérience.",
    questions: [
      { prompt: "Avez vous trouvé une façon de faire la tâche sans lire la phrase entière ?",
        options: ["Oui", "Non"],
        labels: ["has-strategy-to-skip", "no-strategy-to-strategy"],
        required: false,
      },
      { prompt: "Si vous avez répondu oui, pourriez vous brièvement la décrire ci-dessous ?", htmlType: "text",  required: false},
      { prompt: "Avez vous trouvé les phrases bizarres ? (1: très naturelles, 10: très bizarres)",
        htmlType: "likert",
        required: false,
      },
      { prompt: "Avez vous trouvé la tâche difficile ? (1: très simple, 10: très difficile)",
        htmlType: "likert",
        required: false,
      },
    ],
    button_label: "Continuer",
  };
}
survey_posthoc.on_start = function(data) {
  document.body.style.cursor = 'pointer';
}

gen_instructions = function() {
  instruction = []
  if (lang === "en") {
    instruction_p1 = '<div id="consent"><section id="consent_body"><h2>Instructions page 1</h2>'
    instruction_p1 += '<ul>'
    instruction_p1 += '<li>This experiment is about <strong>sentence</strong> processing</li>'
    instruction_p1 += '<li>You will read sentences on the screen, with the words presented <strong>one after the other, at the center of the screen</strong></li>'
    instruction_p1 += '<li>Some of these sentences will contain mistakes</li>'
    instruction_p1 += '<li>Your task is to <strong>find these mistakes</strong></li>'
    instruction_p1 += '</ul></section></div>'
    instruction_p2 = '<div id="consent"><section id="consent_body"><h2>Instructions page 2</h2>'
    instruction_p2 += '<p>Here are a few examples to show what we mean by correct and incorrect. Remember that the sentence will not be presented as a whole, but rather one word after another.</p>'
    instruction_p2 += '<h3>Incorrect examples:</h3>'
    instruction_p2 += '<ol>'
    instruction_p2 += '<li>The boy <span class="error">drink</span> water while listening to music</li>'
    instruction_p2 += '<li>The farmer near the two <span class="error">pilot</span> detests boxing</li>'
    instruction_p2 += '<li>The athletes that dislike the happy proud banker <span class="error">sings</span></li>'
    instruction_p2 += '</ol>'
    instruction_p2 += '<h3>Correct examples:</h3>'
    instruction_p2 += '<ol>'
    instruction_p2 += '<li>The boy <span>drinks</span> water while listening to music</li>'
    instruction_p2 += '<li>The farmer near the two <span>pilots</span> detests boxing</li>'
    instruction_p2 += '<li>The athletes that dislike the happy proud banker <span>sing</span></li>'
    instruction_p2 += '</ol><p>Some sentences might be a bit weird, like in 3, but you should always be able to perform the task if you remain focused.</p>'
    instruction_p2 += '</section></div>'
    instruction_p3 = '<div id="consent"><section id="consent_body"><h2>Instructions page 3</h2>'
    instruction_p3 += '<p>You have to look at the cross at the center of the screen, which is always present when there is no word to read. Then you will read sentences one word after the other and you have to do the following:</p>'
    instruction_p3 += '<ul>'
    instruction_p3 += '<li>As soon as you think a given sentence is <strong>INCORRECT</strong>, please press the <strong>'
    instruction_p3 += (leftIsCorrect ? "➡ right arrow" : "⬅ left arrow")
    instruction_p3 += '</strong> key on your keyboard</li>'
    instruction_p3 += '<li>When the sentence ends, if you think it is <strong>CORRECT</strong>, please press the <strong>'
    instruction_p3 += (leftIsCorrect ? "⬅ left arrow" : "➡ right arrow")
    instruction_p3 += '</strong> key on your keyboard</li>'
    instruction_p3 += "<li>You have to answer <strong>every time</strong>, even when you're not sure or you feel you don't know. Answer the best you can!</li>"
    instruction_p3 += '</ul><p>After each answer you will receive feedback: the central cross will turn <span class="ok">green</span> if you answered correctly, and <span class="error">red</span> otherwise. If you can, please turn your computer audio on: that way, you will receive feedback with sounds for each trial.</p>'
    instruction_p3 += '<p>This is the last instruction page. You can go back to the other pages still, but when you move forward the experiment ask you to go fullscreen. Then the experiment will start with 5 training examples so that you understand the task.</p></section></div>'
    return [instruction_p1, instruction_p2, instruction_p3]
  }
  if (lang === "fr") {
    return "TODO"
  }
}

gen_fullscreen = function(lang) {
  var prompt;
  var fullscreen;
  if (lang == "en") {
    fullscreen = {
      type: "fullscreen",
      fullscreen_mode: true,
      message: prompt,
      button_label: "Switch to fullscreen and start training",
    };
  } else if (lang == "fr") {
    fullscreen = {
      type: "fullscreen",
      fullscreen_mode: true,
      message: prompt,
      button_label: "Passer en plein écran et commencer",
    };
  }
  fullscreen.on_finish = function(data) {
    document.body.style.cursor = 'none';
  }
  return fullscreen;
}

var transition;
if (lang == "en") {
  transition = "The experiment will start now";
} else if (lang == "fr") {
  transition = "L'expérience va commencer maintenant";
}

add_congrats = function (content, score) {
  if (lang == "en") {
    content.innerHTML =
      "<h1>Congrats! You succeeded on " +
      Math.round((100 * score)) +
      "% of the trials!</h1>";
  } else if (lang == "fr") {
    content.innerHTML =
      "<h1>Félicitations ! Vous avez un taux de succès de " +
      Math.round((100 * score)) +
      "% !</h1>";
  }
};

shareScore = function(content, score) {
  link_fb = "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fprivate.unicog.org%2Fmsm%2Flanguage%2Fexperiment%2F"
  link_twitter = "https://twitter.com/intent/tweet?text="
  link_mail = "mailto:?subject="
  if (lang == "en") {
    link_twitter += encodeURIComponent("I scored " + score + " on https://private.unicog.org/msm/language/experiment — match me! #Language")
    header = "Help us by sharing this experiment on social media:"
    link_mail += encodeURIComponent("Experiment on Language")
  }
  else if (lang == "fr") {
    link_twitter += encodeURIComponent("J'ai un score de " + score + " sur https://private.unicog.org/msm/language/experiment — tu peux faire mieux ? #Langage")
    header = "Aidez nous en partageant cette expérience sur les réseaux sociaux :"
    link_mail += encodeURIComponent("Expérience sur la Langage")
  }
  link_mail += "&body=" + encodeURIComponent("https://private.unicog.org/msm/langage/experiment")
  content_add = "<h4>" + header + "</h4>";
  content_add += '<a class="social" href='+link_twitter+' target="_blank" rel="noopener noreferrer"><img src='+twitter_icon+'></a>';
  content_add += '<a class="social" href='+link_fb+' target="_blank" rel="noopener noreferrer"><img src='+fb_icon+'></a>';
  content_add += '<a class="social" href="'+link_mail+'" target="_blank" rel="noopener noreferrer"><img src='+mail_icon+'></a>';
  content.innerHTML += content_add;
};

var correct_str = "CORRECT";
var incorrect_str = "INCORRECT";
