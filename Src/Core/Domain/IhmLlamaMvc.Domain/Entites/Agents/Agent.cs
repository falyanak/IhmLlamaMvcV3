using IhmLlamaMvc.Domain.Entites.Conversations;
using IhmLlamaMvc.SharedKernel.Primitives;

namespace IhmLlamaMvc.Domain.Entites.Agents
{
    public class Agent :EntityBase<int>
    {
        public Agent(string nom, string prenom)
        {
            Nom = nom;
            Prenom = prenom;
        }
        public string Nom { get; set; }
        public string Prenom { get; set; }

        public ICollection<Conversation> Discussions { get; set; }
    }
}
