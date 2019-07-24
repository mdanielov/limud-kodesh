using HebrewTexts.Logic.DTOs;
using HebrewTexts.Logic.Persistence.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace HebrewTexts.API.Controllers
{
    [RoutePrefix("api/ContentGroups")]
    public class ContentGroupsController : ApiController
    {
        [HttpGet,Route("Main")]
        public IEnumerable<ContentGroupDto> GetMainGroups() {
            var repo = new ContentGroupsRepository(user:null);
            var result = repo.GetMainGroups().ToDto();
            return result;
        }

        [HttpGet, Route("{parentGroupID}/Children")]
        public dynamic GetGroupsByParent(int parentGroupID)
        {
            var user = LogicAppUsersRepository.GetUser(loginPrincipalUser: User);

            var repo = new ContentGroupsRepository(user: user);
            var result = repo.GetChildren(parentGroupID).OrderBy(g=>g.SequenceNumber).ToDto(user);
            var info = repo.GetAncestors(parentGroupID).ToList().ToDto(user);
            return new { Data = result, AdditionalInformation = new { Ancestors = info } };
        }

    }
}
