using HebrewTexts.DAL;
using HebrewTexts.DAL.Persistence.Repositories;
using HebrewTexts.Logic.DTOs;
using HebrewTexts.Logic.DTOs.DtoConvertors;
using HebrewTexts.Logic.Persistence.Repositories;
using HebrewTexts.Logic.UIServices.Search;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace HebrewTexts.API.Controllers
{
    public class ContentController : ApiController
    {
        [HttpGet, Route("api/ContentGroups/{groupID}/Content")]
        public List<MainContentDto> GetContentByGroupID(int groupID, [FromUri] int take = 100, [FromUri]  int skip = 0)
        {
            var user = LogicAppUsersRepository.GetUser(loginPrincipalUser: User);
            var repo = new MainContentRepository(user);
            return repo.GetByGroupID(groupID: groupID).ToDto(user).ToList();
        }

        [HttpGet]
        public List<List<MainContentDto>> AutoComplete(string input)
        {
            var ac = new AutoCompleteContent();
            return ac.GetByInput(input: input);

        }


    }
}
