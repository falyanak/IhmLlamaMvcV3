namespace IhmLlamaMvc.Domain.Entites.Conversations
{
    public interface IConversationRepository
    {
        public void CreerConversation(Conversation  conversation);
        public void ListerConversationAgent(string loginWindows);
        public void SupprimerUneConversation(int conversationId);
        public void SupprimerToutesLesConversations(int agentId);
    }
}
