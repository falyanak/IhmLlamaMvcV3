using IhmLlamaMvc.Domain.Entites.Reponses;
using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Domain.Entites.Questions
{
    public class Question :EntityBase<int>
    {
        public Question(string libelle)
        {
            Libelle = libelle;
        }

        public string Libelle { get; set; }

        //public int reponseId { get; set; } // Required foreign key property
        public Reponse Reponse { get; set; }
    }
}
