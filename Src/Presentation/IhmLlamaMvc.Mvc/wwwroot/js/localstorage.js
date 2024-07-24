const QUESTION_VALEUR_MAX_ID = "QUESTION_VALEUR_MAX_ID";
const REPONSE_VALEUR_MAX_ID = "REPONSE_VALEUR_MAX_ID";

// mémorisation en session d'un objet pour une clé donnée
function storeObjectInSessionStorage(key, object, stringified = true) {

    const jsonStringified = stringified ? JSON.stringify(object) : object;

    //   console.log("jsonStringified = " + jsonStringified);

    sessionStorage.setItem(key, jsonStringified);
}

// lecture de l'objet mémorisé en session pour une clé donnée
function restoreObjectInSessionStorage(key, parsing = true) {

    if (key in sessionStorage) {
        const value = parsing ? JSON.parse(sessionStorage.getItem(key)) : sessionStorage.getItem(key);

        //   console.log("jsonParsed = " + jsonParsed);

        return value;
    }

    return null;
}

function removeObjectInSessionStorage(key) {
    if (key in sessionStorage) {
        sessionStorage.removeItem(key);
        return true;
    }
    return false;
}

function clearSessionStorage() {
    localStorage.clear();
}