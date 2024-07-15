using IhmLlamaMvc.Domain.Entites;
using IhmLlamaMvc.Domain.Entites.Conversations;
using Microsoft.CodeAnalysis.CSharp;

namespace IhmLlamaMvc.Application.Interfaces
{
    public interface IChatIaService
    {
        public Conversation DemarrerConversation();
        public void TerminerConversation(Conversation conversation);
        public string GetAnswer(string question);
    }
}
