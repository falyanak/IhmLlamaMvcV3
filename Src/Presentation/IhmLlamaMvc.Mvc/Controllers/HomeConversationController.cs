using IhmLlamaMvc.Application.UseCases.Conversations.Commands;
using Microsoft.AspNetCore.Mvc;

namespace IhmLlamaMvc.Mvc.Controllers
{
    public partial class HomeController
    {
        [HttpPost]
        public async Task<IActionResult> GetAnswer([FromBody] CreerQuestionRequete requete)
        {
            var reponse = await _sender.Send(requete);
            return new JsonResult(reponse);
        }
    }
}