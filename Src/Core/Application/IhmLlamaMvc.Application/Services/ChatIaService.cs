using IhmLlamaMvc.Application.Interfaces;
using IhmLlamaMvc.Domain.Entites.IaModels;

namespace IhmLlamaMvc.Application.Services
{
    public partial class ChatIaService : IChatIaService
    {
        private readonly ICallIaModel _callIaModel;
        private readonly IModelIARepository _modelIaRepository;

        public ChatIaService(ICallIaModel callIaModel, 
            IModelIARepository modelIaRepository)
        {
            _callIaModel = callIaModel;
            _modelIaRepository = modelIaRepository;
        }


    }
}
