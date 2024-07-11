using IhmLlamaMvc.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.SemanticKernel.ChatCompletion;
using Microsoft.SemanticKernel;
using System.Diagnostics;
using System.Text;


namespace IhmLlamaMvc.Controllers
{
    // bidoullage pour faire fonctionner les requetes json depuis JS
    public class Requete
    {
        public string question { get; set; }
    }

    public partial class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
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

        public IActionResult ShowIaPrompt()
        {
            return View();
        }

        
    }
}