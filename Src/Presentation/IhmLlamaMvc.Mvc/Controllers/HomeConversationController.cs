using Azure.Core;
using Microsoft.AspNetCore.Mvc;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.ChatCompletion;
using System.Text;


namespace IhmLlamaMvc.Controllers
{


    public partial class HomeController : Controller
    {

        //Ce code C# appartient à un contrôleur ASP.NET Core et définit une action HTTP POST
        //Cette annotation indique que la méthode GetAnswer doit répondre aux requêtes HTTP POST.
        //Cela signifie que cette méthode sera invoquée lorsque le serveur reçoit une requête POST
        //à l'URL associée à cette action.
        [HttpPost]
        public async Task<IActionResult> GetAnswer([FromBody] Requete requete)
        {

            // Initialize the Semantic kernel
            var kernelBuilder = Kernel.CreateBuilder();
#pragma warning disable SKEXP0010 // Le type est utilisé à des fins d’évaluation uniquement et est susceptible d’être modifié ou supprimé dans les futures mises à jour. Supprimez ce diagnostic pour continuer.
            var kernel = kernelBuilder
                .AddOpenAIChatCompletion( // We use Semantic Kernel OpenAI API
                    modelId: "llama3",
                    apiKey: null,
                    endpoint: new Uri("http://localhost:11434")) // With Ollama OpenAI API endpoint
                .Build();
#pragma warning restore SKEXP0010 // Le type est utilisé à des fins d’évaluation uniquement et est susceptible d’être modifié ou supprimé dans les futures mises à jour. Supprimez ce diagnostic pour continuer.

            // Create a new chat
            var ai = kernel.GetRequiredService<IChatCompletionService>();
            ChatHistory chat = new("answer with afection like i am your creator but dont be cringe");
            StringBuilder builder = new();

            // User question & answer loop
            string Sortie = requete.question;
            chat.AddUserMessage(Sortie);

            builder.Clear();

            // Get the AI response streamed back to the console
            await foreach (var message in
                           ai.GetStreamingChatMessageContentsAsync(chat, kernel: kernel))
                //on connait pas le temps donc await
            {
                Console.Write(message);
                builder.Append(message.Content);
            }

            chat.AddAssistantMessage(builder.ToString());
            string result = builder.ToString();
            Console.WriteLine("Dernier message : " + result);
            return new JsonResult(result);


        }

    }
}