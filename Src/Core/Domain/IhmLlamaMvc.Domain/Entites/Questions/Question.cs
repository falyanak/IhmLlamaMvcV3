using IhmLlamaMvc.Domain.Entites.Reponses;
using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Domain.Entites.Questions
{
    public class Question :EntityBase<int>
    {
        public string Libelle { get; set; }

        public Reponse ReponseDonnee { get; set; }
    }
}
