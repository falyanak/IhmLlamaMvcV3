﻿using IhmLlamaMvc.Application.Interfaces;
using IhmLlamaMvc.Domain.Entites;

namespace IhmLlamaMvc.Application.Services
{
    public class ChatIaService : IChatIaService
    {
        public Conversation DemarrerConversation()
        {
            throw new NotImplementedException();
        }

        public void TerminerConversation(Conversation conversation)
        {
            throw new NotImplementedException();
        }

        string IChatIaService.GetAnswer(string question)
        {
            throw new NotImplementedException();
        }
    }
}