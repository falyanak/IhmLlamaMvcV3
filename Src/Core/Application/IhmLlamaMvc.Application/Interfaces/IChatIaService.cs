using IhmLlamaMvc.Domain.Entites.Conversations;

namespace IhmLlamaMvc.Application.Interfaces
{
    public interface IChatIaService
    {
        public Conversation DemarrerConversation();
        public void TerminerConversation(Conversation conversation);
        public  Task<string> GetAnswer(string question);
    }
}
