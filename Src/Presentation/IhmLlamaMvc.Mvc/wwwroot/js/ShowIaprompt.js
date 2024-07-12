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

    requete.focus()
};


// envoi de la question au serveur Paolo

function PostData1(event) {
    fetch('/api/openai/stream?prompt=Hello%20World')
        .then(response => {
            const reader = response.body.getReader();
            const decoder = new TextDecoder('utf-8');
            const stream = new ReadableStream({
                start(controller) {
                    function push() {
                        reader.read().then(({ done, value }) => {
                            if (done) {
                                controller.close();
                                return;
                            }
                            controller.enqueue(decoder.decode(value));
                            push();
                        }).catch(err => {
                            console.error('Error reading stream:', err);
                            controller.error(err);
                        });
                    };
                    push();
                }
            });

            return new Response(stream, { headers: { 'Content-Type': 'text/plain' } });
        })
        .then(response => response.text())
        .then(text => {
            // Process the streamed text here
            console.log(text);
        })
        .catch(err => console.error('Error fetching data:', err));

}
async function postData(event) {

    event.preventDefault();

    const element = document.getElementById("requete");
    const queryInput = element.value;
    console.log(queryInput);

    element.disabled = true;

    addEntryToHistory(queryInput);

    const postdata = { question: queryInput };

    alert(queryInput);
    // Afficher l'animation de chargement
 //   document.getElementById("animChargement").style.display = 'block';
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

  //  document.getElementById("animChargement").style.display = 'none';
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
    newEntry.className = "list-group-item";
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


//var input = document.getElementById("requete");
//input.addEventListener("keypress", function (event) {
//    // If the user presses the "Enter" key on the keyboard
//    if (event.key === "Enter") {
//        // Trigger the button element with a click
//        if (event.shiftKey) {
//            // Ne rien faire et permettre le comportement par défaut (insertion d'une nouvelle ligne)
//            return;
//        }
//        event.preventDefault();
//        postData();
//        input.setSelectionRange(0, 0);
//        input.focus(); // Assurer que l'élément est focalisé
//    }
//}); 



