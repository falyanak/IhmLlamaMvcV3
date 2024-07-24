window.onload = function () {
    //    alert("onload")
    hideBusyIndicator();
    // Écouteur d'événement pour le bouton de réinitialisation
    document.getElementById("resetButton").addEventListener("click", function () {
        resetConversation();
    });
    document.getElementById("searchForm").addEventListener("submit", function (event) {
        postData(event);
    });

    document.getElementById("listemodeles").addEventListener("change", function (event) {
        changeTitle(event);
    });


    requete.focus()
};


// envoi de la question au serveur Paolo

async function postData(event) {

    event.preventDefault();

    const element = document.getElementById("requete");
    const queryInput = element.value;
    console.log(queryInput);

    element.disabled = true;

    addEntryToHistory(queryInput);

    const postdata = { question: queryInput };

    // afficher l'indicateur de chargement
    displayBusyIndicator();

    let request = {
        method: 'POST',
        body: JSON.stringify(postdata),
        headers: {
            "content-type": 'application/json; charset=UTF-8',
        },
    };
    const reponse = await fetch('/Home/GetAnswer', request);
    const json = await reponse.json(); //récupère la rep de l'ia
    console.log(json);
    element.disabled = false;

    // cacher l'indicateur de chargement
    hideBusyIndicator();

    successFunc(json);
}

function successFunc(data) {
    document.getElementById("Output").value = data;
}

function errorFunc() {
    alert('error');
}

function addEntryToHistory(entry) {
    const historyList = document.getElementById("historyList");
    const newEntry = document.createElement("li");
    // newEntry.className = "list-group-item";
    newEntry.textContent = entry;
    historyList.appendChild(newEntry);
}


function resetConversation() {
    // Vide la zone de texte
    document.getElementById("requete").value = "";

    // Vide la liste de l'historique
    document.getElementById("historyList").innerHTML = "";

    // Vide la sortie de l'IA
    document.getElementById("Output").value = "";

    requete.focus();
}

function changeTitle(event) {
    const select = event.target;
    const value = select.value;
    console.log(`selection value = ${value}`);
    const selection = select.options[select.selectedIndex].text;

    console.log(`selection text = ${selection}`);

  //  autoriserSaisieIhm(true);

    if (value == "0") {
        console.log(`value == '0'`);
        interdireSaisieIhm(true);
        document.getElementById("headerlabel").innerHTML = "Sélectionner un modèle";
    }
    else {
        interdireSaisieIhm(false);
        document.getElementById("headerlabel").innerHTML = "Conversation avec " + selection;
    }
   
}

function interdireSaisieIhm(accessibilite = false) {
    console.log(`accessibilite IHM = ${accessibilite}`);
    resetConversation();
    document.getElementById("requete").disabled = accessibilite;
    document.getElementById("rechercher").disabled = accessibilite;
}






