using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;

namespace HebrewTexts.API
{
    public class LogicAppUsersRepository
    {
        public static AppUser GetUser(IPrincipal loginPrincipalUser)
        {
            // return AppUser.GetForTests(loginPrincipalUser.Identity.Name);
            return AppUser.GetForTests();
        }
    }
}