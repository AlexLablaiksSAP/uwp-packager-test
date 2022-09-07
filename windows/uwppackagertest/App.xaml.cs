using Microsoft.ReactNative;
#if USE_WINUI3
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
#else
using Windows.ApplicationModel.Activation;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
#endif

namespace uwppackagertest
{
	public sealed partial class App : ReactApplication
	{
		public App()
		{
			InstanceSettings.UseWebDebugger = false;
			JavaScriptBundleFile = "index";
			InstanceSettings.UseDirectDebugger = true;
			InstanceSettings.UseFastRefresh = true;
			InstanceSettings.UseDeveloperSupport = true;

			Microsoft.ReactNative.Managed.AutolinkedNativeModules.RegisterAutolinkedNativeModulePackages(PackageProviders); // Includes any autolinked modules

			PackageProviders.Add(new ReactPackageProvider());

			InitializeComponent();
		}

		/// <summary>
		/// Invoked when the application is launched normally by the end user.  Other entry points
		/// will be used such as when the application is launched to open a specific file.
		/// </summary>
		/// <param name="e">Details about the launch request and process.</param>
		protected override void OnLaunched(LaunchActivatedEventArgs e)
		{
			base.OnLaunched(e);
			Frame frame = (Frame)Window.Current.Content;
			frame.Navigate(typeof(MainPage), e.Arguments);
		}

		/// <summary>
		/// Invoked when the application is activated by some means other than normal launching.
		/// </summary>
		protected override void OnActivated(Windows.ApplicationModel.Activation.IActivatedEventArgs e)
		{
			UIElement preActivationContent = Window.Current.Content;
			base.OnActivated(e);
			if (preActivationContent == null && Window.Current != null)
			{
				// Display the initial content
				Frame frame = (Frame)Window.Current.Content;
				frame.Navigate(typeof(MainPage), null);
			}
		}
	}
}
