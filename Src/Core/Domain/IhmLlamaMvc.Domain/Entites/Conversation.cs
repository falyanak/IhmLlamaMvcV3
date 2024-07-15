using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Domain.Entites
{
    public class Conversation : EntityBase<Guid>
    {
        public  string Intitule { get; set; }
        public DateTime Debut { get; set; }
        public DateTime Fin { get; set; }

        public ICollection<Question> Discussions { get; set; }
    }
}
