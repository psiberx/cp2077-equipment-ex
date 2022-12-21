public native struct gameuiPuppetPreviewCameraSetup {
    public native let slotName: CName;
    public native let cameraZoom: Float;
    public native let interpolationTime: Float;
}

public native struct gameuiPuppetPreviewCameraController {
    public native let cameraSetup: array<gameuiPuppetPreviewCameraSetup>;
    public native let activeSetup: Uint32;
    public native let transitionDelay: Float;
}

@addField(inkPuppetPreviewGameController)
public native let cameraController: gameuiPuppetPreviewCameraController;
