using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Xunit;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Builder;


public class CustomWebApplicationFactory : WebApplicationFactory<SimpleWebApp.Program>
{
    protected override IHostBuilder CreateHostBuilder()
    {
        return WebApplication.CreateBuilder();
    }
}

namespace SimpleWebApp.Tests
{
    public class WebAppTests : IClassFixture<CustomWebApplicationFactory>
    {
        private readonly HttpClient _client;

        public WebAppTests(CustomWebApplicationFactory factory)
        {
            _client = factory.CreateClient();
        }

        [Fact]
        public async Task HomePage_ShouldReturnSuccessStatusCode()
        {
            // Act
            var response = await _client.GetAsync("/");

            // Assert
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        }
    }
}

