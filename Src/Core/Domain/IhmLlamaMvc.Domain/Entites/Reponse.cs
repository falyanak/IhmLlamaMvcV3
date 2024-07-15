using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Domain.Entites
{
     public class Reponse : EntityBase<Int32>
    {
        public string Libelle { get; set; }

        public Question QuestionPosee { get; set; }
    }
}
