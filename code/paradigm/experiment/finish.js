// Function to POST the data and save it
function SaveData(project, filename, filedata) {
  var xhr = new XMLHttpRequest();

  xhr.open('POST', '/msm/save-data.php');
  xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
  xhr.onload = function() {
    if (xhr.status === 200 && xhr.responseText !== "GOT IT") {
        // document.body.innerHTML += xhr.responseText;
    }
    else if (xhr.status !== 200) {
        alert('Request failed.  Returned status of ' + xhr.status);
    }
  };

  xhr.send(encodeURI('project=' + project+'&filename=' + filename+'&filedata=' + filedata));
}

finish_experiment = function(data) {

  document.body.style.cursor = 'pointer';
  try {
    if (document.exitFullscreen) {
      document.exitFullscreen();
    } else if (document.msExitFullscreen) {
      document.msExitFullscreen();
    } else if (document.mozCancelFullScreen) {
      document.mozCancelFullScreen();
    } else if (document.webkitExitFullscreen) {
      document.webkitExitFullscreen();
    }
  } catch(e) {
    // Ignore : not being able to exit fullscreen means we're already not in
    // fullscreen which is OK
  }
  overallScore = globalScore / globalNTrials;
  content = document.getElementById("jspsych-content");

  add_congrats(content, overallScore);
  shareScore(content, "" + Math.round(overallScore*100) + "%");

  // Uncomment when publishing
  SaveData("ctm_language_v1", subjectID, data.csv());
}
