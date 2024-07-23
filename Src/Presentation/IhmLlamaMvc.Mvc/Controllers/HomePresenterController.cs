using IhmLlamaMvc.Domain.Entites.IaModels;
using IhmLlamaMvc.SharedKernel.Primitives.Result;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace IhmLlamaMvc.Mvc.Controllers
{
    public partial class HomeController
    {
        private static IEnumerable<SelectListItem> ConstruireListeFormateeModelesIA(
            Result<IReadOnlyList<ModeleIA>> listeModelesIA)
        {
            IEnumerable<SelectListItem> listeFormatee = listeModelesIA.Value
                .Select(x => new SelectListItem
                {
                    Value = x.Id.ToString(),
                    Text = string.Format("{0} version {1}", x.Libelle, x.Version),
                    Selected = x.Libelle.Contains("LLama")

                });

            return listeFormatee;
        }
    }
}