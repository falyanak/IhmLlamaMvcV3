using IhmLlamaMvc.Application.UseCases.Conversations.Commands;
using IhmLlamaMvc.Application.UseCases.IaModels.Queries;
using IhmLlamaMvc.Mvc.Constants;
using IhmLlamaMvc.Mvc.Extensions;
using IhmLlamaMvc.Mvc.ViewModels.Conversation;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using ReferentielAPI.Entites;

namespace IhmLlamaMvc.Mvc.Controllers
{
    public partial class HomeController
    {
        public async Task<IActionResult> ShowIaPrompt()
        {
            var listeModelesIA = await _sender.Send(new ListerModelesIAQuery());

            var conversationViewModel =
               await CopierInfosVersConversationViewModel(listeModelesIA.Value);

            return View(conversationViewModel);
        }



        [HttpPost, ActionName("PoserQuestion")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PoserQuestion(CreerQuestionRequete requete)
        {
            var reponse = await _sender.Send(requete);
            return new JsonResult(reponse);
        }
    }
}