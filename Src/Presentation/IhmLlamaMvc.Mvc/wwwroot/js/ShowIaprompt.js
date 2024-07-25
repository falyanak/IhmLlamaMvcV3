window.onload = function () {
    //    alert("onload")
    hideBusyIndicator();
    // Écouteur d'événement pour le bouton de réinitialisation
    document.getElementById("resetButton").addEventListener("click", function () { resetConversation(); });
    document.getElementById("searchForm").addEventListener("submit", function (event) { postData(event); });

    const textareas = document.querySelectorAll("textarea");
    //  var test = document.querySelectorAll('input[value][type="checkbox"]:not([value=""])

    const questions = document.querySelectorAll(".questionclass");
    console.log(questions);

    const reponses = document.querySelectorAll(".reponseclass");
    console.log(reponses);

    document.getElementById("Question").addEventListener("keyup", function (event) {
        if (event.key === 'Enter') {
           
            alert('Enter is pressed in the form');
            document.getElementById("searchForm").requestSubmit();

        }
    });

    textareas.forEach(function (i) {
        i.addEventListener('input', function () {
            console.log("on input");
            setDynamicHeight(this);
        });
    });

    //textareas.forEach(function (i) {
    //    i.addEventListener('change', function () {
    //        console.log("on change");
    //        setDynamicHeight(this);
    //    });
    //});
    clearSessionStorage();
    storeObjectInSessionStorage(QUESTION_VALEUR_MAX_ID, 0);
    storeObjectInSessionStorage(REPONSE_VALEUR_MAX_ID, 0);
  
    Question.focus()
};

// envoyer les données du formulaire au serveur
async function postData(event) {

    event.preventDefault();

    // empêcher la saisie pendant la soumission du formulaire
    preventInputData(true);

    // afficher le sablier
    showBusyIndicator();

    const f = document.getElementById("searchForm");
    const formData = new FormData(f);
    console.log(formData);

    const url = $('#mapconversation').data('url-soumettre-formulaire-link');

    var errorResponse;

    try {
        const response = await fetch(url, {
            method: "POST",
            body: formData
        });

        const result = await response.json();
        console.log("Success:", result);

        if (!response.ok) {
            errorResponse = result;
            throw new Error("Une erreur s'est produite !");
        }

  //      alert(result);

        // rendre l'IHM disponible pour la saisie
        preventInputData(false);

        // cacher l'indicateur de chargement
        hideBusyIndicator();

        // afficher la question
        showQuestion();

        // afficher la réponse
        showResponse(result);

        document.getElementById("Question").value = "";


    } catch (error) {
        console.log("Error:", error);

        //extraire les erreurs au format object{ code: string, message : string }
        if (errorResponse && errorResponse.errors) {
            const errorList = errorResponse.errors;
            showAlert("Une erreur est survenue", "message", "danger", errorList,
                { autoClose: false })
        }
        else {
            const errorList = [{ code: "Une erreur s'est produite", message: error }];
            showAlert("Une erreur est survenue", "message", "danger", errorList,
                { autoClose: false })
        }
    }
}

function errorFunc() {
    alert('error');
}

function resetConversation() {
    // Vide la zone de texte
    document.getElementById("Question").value = "";
    document.getElementById("Question").style.height = "10%";

    // effacer les questions et réponses
    const parent = document.getElementById("showQuestionAnswer");
    while (parent.firstChild) {
        parent.firstChild.remove()
    }

    document.getElementById("Question").focus();
}

function preventInputData(actionValue = false) {
    console.log(`accessibilite IHM = ${actionValue}`);

    document.getElementById("Question").readOnly = actionValue;
    document.getElementById("rechercher").readOnly = actionValue;
}

function setDynamicHeight(element) {
    element.style.height = 0; // set the height to 0 in case of it has to be shrinked
    element.style.height = element.scrollHeight + 'px'; // set the dynamic height
}


function showResponse(data) {

    const nextId = getReponseMaxId();

    const dataWithPrefix = `IA : ${data}`;
    createTextareaAnswer(nextId, dataWithPrefix);

    const id = `reponseId-${nextId}`;

    const answer = document.getElementById(id);

    alert(answer.name);

    setDynamicHeight(answer);

    answer.value = data;
}


function getReponseMaxId() {
    let id = restoreObjectInSessionStorage(REPONSE_VALEUR_MAX_ID);
    console.log(`getReponseMaxId = ${id}`);

    id = parseInt(id, 10) + 1;

    console.log(`getReponseMaxId après incrément = ${id}`);
  
    // stocker la nouvelle valeur
    storeNewMaxId(REPONSE_VALEUR_MAX_ID, id);

    console.log(`stockage en session de REPONSE_VALEUR_MAX_ID = ${id}`);
    return id;
}


function createTextareaAnswer(nextId, content) {
    var input = document.createElement('textarea');
    input.name = `reponseId-${nextId}`;
    input.id = `reponseId-${nextId}`;

    input.readOnly = true;
    input.className = 'reponseclass';
    input.innerText = content;

    const parent = document.querySelector("#showQuestionAnswer");

    parent.appendChild(input);
}


function createTextareaQuestion(nextId, content) {
    var input = document.createElement('textarea');
    input.name = `questionId-${nextId}`;
    input.id = `questionId-${nextId}`;

    input.readOnly = true;
    input.className = 'questionclass';
    input.innerText = content;

    const parent = document.querySelector("#showQuestionAnswer");

    parent.appendChild(input);
}

function getQuestionMaxId() {
    let id = restoreObjectInSessionStorage(QUESTION_VALEUR_MAX_ID);
    console.log(`getQuestionMaxId = ${id}`);

    id = parseInt(id, 10) + 1;
    console.log(`getQuestionMaxId après incrément = ${id}`);

    // stocker la nouvelle valeur
    storeNewMaxId(QUESTION_VALEUR_MAX_ID, id);

    console.log(`stockage en session de QUESTION_VALEUR_MAX_ID = ${id}`);

    return id;
}

function storeNewMaxId(key, valueId) {
    // stocker la nouvelle valeur
    storeObjectInSessionStorage(key, valueId);
}

function showQuestion() {

    const nextId = getQuestionMaxId();

    const data = document.getElementById("Question").value;

    const initiales = document.getElementById("InitialesAgent").value;
    const dataWithPrefix = `${initiales} : ${data}`;

    createTextareaQuestion(nextId, dataWithPrefix);

    const id = `questionId-${nextId}`;

    const question = document.getElementById(id);

    alert(`question = ${question}`);

    setDynamicHeight(question);

    // recopier question dans nouveau textArea
    question.value = data;
}
