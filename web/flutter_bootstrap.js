{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load(
    {
        config: {
            debugShowSemanticNodes:true,
            hostElement: document.getElementById('flutter-container')
        },
        onEntrypointLoaded: async function(engineInitializer) {
            // Initialize the Flutter engine
            let appRunner = await engineInitializer.initializeEngine({});
            // Run the app
            await appRunner.runApp();
          }
    }
);
