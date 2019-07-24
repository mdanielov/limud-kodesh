using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace HebrewTexts.API
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);


            GlobalConfiguration.Configuration.Formatters.JsonFormatter.SerializerSettings
.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
            GlobalConfiguration.Configuration.Formatters
                .Remove(GlobalConfiguration.Configuration.Formatters.XmlFormatter);

        }


        /// <summary>
        /// http://stackoverflow.com/questions/40104158/cors-not-working-in-web-api-2-0
        /// פונקציה זו מכסה את כל נושא האבטחה של האוריגין לענפיו וסוגיו
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <remarks>תוספת מיוחדת למערכת</remarks>
        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            var context = HttpContext.Current;
            var response = context.Response;
            //response.Headers.Remove("Access-Control-Allow-Origin");
            response.AddHeader("X-Frame-Options", "ALLOW-FROM *");

            response.AddHeader("Access-Control-Expose-Headers", "X-Paging-TotalRecords"); //נועד כדי לאפשר להוסיף כותרות מותאמות אישית שלא יחסמו על ידי הדפדפן
            response.AddHeader("Access-Control-Expose-Headers", "Content-Disposition"); //נועד כדי לאפשר הורדת קבצים

            var origin = context.Request.Headers["origin"];
            if (!string.IsNullOrWhiteSpace(origin))
                response.AddHeader("Access-Control-Allow-Origin", origin);
            else
                response.AddHeader("Access-Control-Allow-Origin", "http://localhost:4200");

            var reqHeaders = context.Request.Headers["Access-Control-Request-Headers"];
            if (!string.IsNullOrWhiteSpace(reqHeaders))
                response.AddHeader("Access-Control-Allow-Headers", reqHeaders);

            response.AddHeader("Access-Control-Allow-Methods", "GET, POST, DELETE, PATCH, PUT");
            if (context.Request.HttpMethod == "OPTIONS")
            {

                response.AddHeader("Access-Control-Max-Age", "1000000");
                response.End();
            }
        }



    }
}
