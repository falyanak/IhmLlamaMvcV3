using IhmLlamaMvc.Domain.Entites.Agents;
using IhmLlamaMvc.Domain.Entites.IaModels;
using IhmLlamaMvc.Domain.Entites.Questions;
using IhmLlamaMvc.SharedKernel.Primitives;
using System.Reflection;

namespace IhmLlamaMvc.Domain.Entites.Conversations
{
    public class Conversation : EntityBase<int>
    {
        public Conversation() { }

        public Conversation(string intitule, DateTime dateCreation, 
            ModeleIA modeleIA, Agent agent, 
            List<Question> questions)
        {
            Intitule = intitule;
            DateCreation = dateCreation;
            ModeleIA = modeleIA;
            Agent = agent;
            Questions = questions;
        }

        public  string Intitule { get; set; }
        public DateTime DateCreation { get; set; }
        public DateTime? DateFin { get; set; }

        public ModeleIA ModeleIA { get; set; }
        public Agent Agent { get; set; }

        public List<Question> Questions { get; set; }
    }
}
