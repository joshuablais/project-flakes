{
  description = "Project flake templates";

  outputs =
    { self }:
    {
      templates = {
        astro = {
          path = ./astro;
          description = "Astro frontend project";
        };
        datastar-go-templ = {
          path = ./datastar-go-templ;
          description = "Go/templ/Datastar web service";
        };
        go-cli = {
          path = ./go/go-cli;
          description = "Go CLI project";
        };
        go-service = {
          path = ./go/go-service;
          description = "Go web service";
        };
        nextjs = {
          path = ./nextjs;
          description = "Next.js project";
        };
        zig = {
          path = ./zig;
          description = "Zig project";
        };
      };

      defaultTemplate = self.templates.datastar-go-templ;
    };
}
