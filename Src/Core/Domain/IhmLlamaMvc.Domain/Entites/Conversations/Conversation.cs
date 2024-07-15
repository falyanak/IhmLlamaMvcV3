using IhmLlamaMvc.Domain.Entites.Agents;
using IhmLlamaMvc.Domain.Entites.IaModels;
using IhmLlamaMvc.Domain.Entites.Questions;
using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Domain.Entites.Conversations
{
    public class Conversation : EntityBase<int>
    {
        public  string Intitule { get; set; }
        public DateTime Debut { get; set; }
        public DateTime Fin { get; set; }

        public IaModel Model { get; set; }
        public Agent Agent { get; set; }

        public ICollection<Question> Discussions { get; set; }
    }
}
