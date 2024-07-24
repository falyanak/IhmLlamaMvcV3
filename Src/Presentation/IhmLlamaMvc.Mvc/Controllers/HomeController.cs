using IhmLlamaMvc.Application.Configurations;
using IhmLlamaMvc.Mvc.Models;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
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

    }
}