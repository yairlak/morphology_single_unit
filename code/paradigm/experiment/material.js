var task = [];
var training = [];

var rawFileExp = new XMLHttpRequest();
var allStimuli;

var correct = [
  new Audio('res/pos1.wav'),
  new Audio('res/pos2.wav'),
  new Audio('res/pos3.wav'),
  new Audio('res/pos4.wav'),
  new Audio('res/pos5.wav'),
  new Audio('res/pos6.wav'),
  new Audio('res/pos7.wav')
]

var incorrect = new Audio('res/neg1.wav');

// Don't hardcode this since it depends on "lang"
rawFileExp.open("GET", "./stimuli/version_02/english_stimuli_filtered_132samples.csv", false);
rawFileExp.onreadystatechange = function ()
{
  if(rawFileExp.readyState === 4)
  {
    if(rawFileExp.status === 200 || rawFileExp.status == 0)
    {
      allStimuli = Papa.parse(rawFileExp.responseText, {delimiter: ",", header: true}).data
      allStimuli = allStimuli.filter(function(e) {return e.correct !== ""});
    }
  }
}
rawFileExp.send(null);

// Now add all of the trials to the main task after shuffling
allStimuli = jsPsych.randomization.shuffle(allStimuli)
for (i = 0 ; i < allStimuli.length ; i++) {
  if (allStimuli[i].sentence !== undefined) {
    allStimuli[i].type = 'rsvp';
    allStimuli[i].correct = (allStimuli[i].violation == "no");
    allStimuli[i].choices = ["leftarrow", "rightarrow"];
    allStimuli[i].presentation_time = 200;
    allStimuli[i].inter_word_time = 5*(1000/30);
    allStimuli[i].training = false;
    task.push(allStimuli[i]);
  }
}

add_train = function(sentence, correct) {
  training.push({
    type: 'rsvp',
    sentence: sentence,
    correct: correct,
    training: true,
    choices: ['leftarrow', 'rightarrow'], presentation_time: 200, inter_word_time: 5*(1000/30),
  });
}

add_train("The boy who loves the beautiful girl leave"          , false)
add_train("The athlete who love the actress smokes"             , false)
add_train("The woman that hates the judge sings"                , true)
add_train("The pastor whom the burglar fears prays"             , true)
add_train("The girl who plays with the young boys run"          , false)
add_train("The barber whom likes watching football climbs"      , false)
add_train("The actor that walks fast but rather clumsily sings" , true)
