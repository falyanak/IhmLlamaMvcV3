window.onload = function () {
    alert("onload")
    // Écouteur d'événement pour le bouton de réinitialisation
    document.getElementById("resetButton").addEventListener("click", function () {
        resetConversation();
    });
    document.getElementById("searchForm").addEventListener("submit", function () {
        postData();
    });
};


// envoi de la question au serveur Paolo
async function postData() {

    var queryInput = document.getElementById("requete").value
    addEntryToHistory(queryInput);  
    document.getElementById("requete").disabled = true;
    document.getElementById("requete").value = '';
    var postdata = { question: queryInput };
    alert(queryInput);
    // Afficher l'animation de chargement
    document.getElementById("animChargement").style.display = 'block';
    let request = {
        method: 'POST',
        body: JSON.stringify(postdata),
        headers: {
            "content-type": 'application/json; charset=UTF-8',
        },
    };
    let reponse = await fetch('/Home/GetAnswer', request);
    let json = await reponse.json(); //récupère la rep de l'ia
    console.log(json);
    document.getElementById("requete").disabled = false;
    successFunc(json);
}

function successFunc(data) {
    
    document.getElementById("Output").value = data;
    document.getElementById("animChargement").style.display = 'none';
}

function errorFunc() {
    alert('error');
}

function addEntryToHistory(entry) {
    var historyList = document.getElementById("historyList");
    var newEntry = document.createElement("li");
    newEntry.className = "list-group-item";
    newEntry.textContent = entry;
    historyList.appendChild(newEntry);
}


function resetConversation() {
    // Vide la zone de texte
    document.getElementById("queryInput").value = "";

    // Vide la liste de l'historique
    document.getElementById("historyList").innerHTML = "";

    // Vide la sortie de l'IA
    document.getElementById("Output").value = "";
}


var input = document.getElementById("requete");
input.addEventListener("keypress", function (event) {
    // If the user presses the "Enter" key on the keyboard
    if (event.key === "Enter") {
        // Trigger the button element with a click
        if (event.shiftKey) {
            // Ne rien faire et permettre le comportement par défaut (insertion d'une nouvelle ligne)
            return;
        }
        event.preventDefault();
        postData();
        input.setSelectionRange(0, 0);
        input.focus(); // Assurer que l'élément est focalisé
    }
}); 



