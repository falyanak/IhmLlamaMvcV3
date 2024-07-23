using IhmLlamaMvc.Domain.Entites.IaModels;
using IhmLlamaMvc.SharedKernel.Primitives.Result;

namespace IhmLlamaMvc.Application.Services
{
    public partial class ChatIaService 
    {
        public async Task<Result<IReadOnlyList<ModeleIA>>> ListerModelesIA()
        {
            return await _modelIaRepository.ChargerModelesIA();
        }
    }
}
