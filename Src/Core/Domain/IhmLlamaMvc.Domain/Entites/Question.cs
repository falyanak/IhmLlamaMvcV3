using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Domain.Entites
{
    public class Question :EntityBase<Int32>
    {
        public string Libelle { get; set; }

        public required Reponse ReponseDonnee { get; set; }
    }
}
