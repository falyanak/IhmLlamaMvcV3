using IhmLlamaMvc.Application.Interfaces;
using IhmLlamaMvc.Domain.Entites;
using IhmLlamaMvc.Domain.Entites.Conversations;

namespace IhmLlamaMvc.Application.Services
{
    public class ChatIaService : IChatIaService
    {
        private readonly ICallIaModel _callIaModel;

        public ChatIaService(
            ICallIaModel callIaModel)
        {
            _callIaModel = callIaModel;
        }

        public Conversation DemarrerConversation()
        {
            throw new NotImplementedException();
        }

        public void TerminerConversation(Conversation conversation)
        {
            throw new NotImplementedException();
        }

        public async Task<string> GetAnswer(string question)
        {
            return await _callIaModel.GetAnswer(question);
        }
    }
}
