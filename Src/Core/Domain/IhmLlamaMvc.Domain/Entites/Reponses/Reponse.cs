using IhmLlamaMvc.Domain.Entites.Questions;
using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Domain.Entites.Reponses
{
     public class Reponse : EntityBase<int>
    {
        public string Libelle { get; set; }

        public Question QuestionPosee { get; set; }
    }
}
