// gestion de l'affichage des messages d'alerte dans le Layout

const showAlert = (msgTitle, msgBody, msgType, errorList, autoClose = false) => {
    let message = "";
    let title = msgTitle;

    if (errorList && errorList.length > 0) {
        title = buildAlertTitle(errorList);
        message = buildAlertHtmlErrorList(errorList);
    }
    else {
        message = `<ul><li>${msgBody}</li></ul>`;
    }

    const alertPlaceholder = document.getElementById('liveAlertPlaceholder');

    const wrapper =
        `<div class="modal fade" tabindex="-1" id="myModal">
        <div class="modal-dialog">
             <div class="modal-content">
                 <div class="modal-header alert-${msgType}">
                     <h5 class="modal-title">
                          &nbsp; ${title}
                     </h5>
                     <button type="button" class="btn-close" data-bs-dismiss="modal" 
                        aria-label="Close" id="BtnFermer"></button>
                 </div>
				 <div class="modal-body alert-${msgType}">
					${message}
				 </div>
			 </div>
		</div>
</div>`;

// attacher à l'élément du Layout
    alertPlaceholder.innerHTML = wrapper;

    $('#myModal').modal('show')
}

const buildAlertHtmlErrorList = (errorList) => {
    let msgBody = "";

    if (errorList && errorList.length > 0) {
        let errorMsgList = "";

        // construire la liste
        errorList.forEach(function (error) { errorMsgList += '<li>' + error.message + '</li>' });

        msgBody += `<ul> ${errorMsgList} </ul>`;
    }
    return msgBody;
}

const buildAlertTitle = (errorList) => {
    let title = "Une erreur est survenue";

    if (errorList && errorList.length > 1) {
        title = "Des erreurs sont survenues";
    }
    return title;
}









