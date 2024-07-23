using IhmLlamaMvc.Application.Configurations;
using IhmLlamaMvc.Application.UseCases.IaModels.Queries;
using IhmLlamaMvc.Domain.Entites.IaModels;
using IhmLlamaMvc.Mvc.Constants;
using IhmLlamaMvc.Mvc.Extensions;
using IhmLlamaMvc.Mvc.Models;
using IhmLlamaMvc.SharedKernel.Primitives.Result;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Options;
using ReferentielAPI.Entites;
using SiccrfAuthorization.Nuget.Interfaces;
using SiccrfWebApiAccess.Nuget.Interfaces;
using System.Diagnostics;

namespace IhmLlamaMvc.Mvc.Controllers
{
    public partial class HomeController : BaseController
    {
        public HomeController(
            ILogger<HomeController> log,
            IWebHostEnvironment webEnvironement,
            IHttpContextAccessor httpContextAccessor,
            IOptions<ApplicationSettings> applicationSettings,
            ISiccrfAuthorizationService siccrfAuthorizationService,
            IWebApiAccessService webapiAccessService,
            ISender sender
        )
            : base(siccrfAuthorizationService, log, applicationSettings, sender)
        {
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public async Task<IActionResult> ShowIaPrompt()
        {
            await GetProfilAgent();

            var agentPermissions = (AgentPermissions)HttpContext.Session.GetJson<AgentPermissions>(
                Constantes.SessionKeyInfosUser);

            ViewData["UserInfos"] = $"{agentPermissions.Prenom} {agentPermissions.Nom}";

            var listeModelesIA = await _sender.Send(new ListerModelesIAQuery());

            IEnumerable<SelectListItem> listeFormatee = ConstruireListeFormateeModelesIA(listeModelesIA);

            ViewData["ModelesIA"] = listeFormatee;

            return View();
        }


    }
}