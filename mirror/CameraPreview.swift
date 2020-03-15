
import Cocoa
import AVFoundation

/// CameraPreview class delegate
protocol CameraPreviewDelegate: AnyObject {
    func didTakeSnapshot(_ snapshot: NSImage)
    func didEncounterError(_ error: Error)
}

/// NSView that holds an AVCaptureVideoPreviewLayer
class CameraPreview: NSView {

    // MARK: - UI Elements
    private lazy var cameraView: NSView = {
        let cameraView = NSView()
        cameraView.wantsLayer = true
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        return cameraView
    }()

    private var previewLayer = AVCaptureVideoPreviewLayer()

    // MARK: - Types

    enum InputType {
        case camera
        case screen
    }

    enum CameraError: Error, LocalizedError {
        case captureDeviceNotFound

        public var errorDescription: String? {
            switch self {
                case .captureDeviceNotFound:
                    return "Camera not found"
            }
        }
    }

    // MARK: - Private Properties

    private lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.addOutput(captureImageOutput)
        return captureSession
    }()

    private lazy var screenInput: AVCaptureScreenInput? = {
        let displayID = NSScreen.screens.last!.displayID
        let displayId: CGDirectDisplayID = CGDirectDisplayID(displayID)
        let input: AVCaptureScreenInput? = AVCaptureScreenInput(displayID: displayId)
        return input
    }()

    private lazy var cameraInput: AVCaptureDeviceInput? = {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                       mediaType: .video,
                                                       position: .unspecified)
        guard let device = session.devices.first else { return nil }
        do {
            return try AVCaptureDeviceInput(device: device)
        } catch {
            self.delegate?.didEncounterError(error)
            return nil
        }
    }()

    private lazy var captureImageOutput: AVCaptureVideoDataOutput = {
        let captureImageOutput = AVCaptureVideoDataOutput()
        captureImageOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        return captureImageOutput
    }()

    /// Returns true if image is flipped, defaults to false
    private(set) var isMirrored: Bool = false

    private(set) var inputType: InputType = .camera

    /// Toggled at takeSnapshot() and AVCaptureVideoDataOutputSampleBufferDelegate
    private var shouldCaptureSnapshot: Bool = false

    // MARK: - Public Properties
    weak var delegate: CameraPreviewDelegate?

    // MARK: - Life Cycle
    init(frame: NSRect = .zero, inputType: InputType = .camera, delegate: CameraPreviewDelegate? = nil, quality: AVCaptureSession.Preset = .photo, isMirrored: Bool = true) {
        super.init(frame: frame)
        self.commonInit(inputType: inputType, delegate: delegate, quality: quality)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit(inputType: InputType = .camera, delegate: CameraPreviewDelegate? = nil, quality: AVCaptureSession.Preset = .photo, isMirrored: Bool = true) {
        self.inputType = inputType
        self.delegate = delegate
        self.isMirrored = isMirrored
        self.setVideoQuality(quality)
        self.addSubview(cameraView)
        self.startPreview(inputType: inputType)
    }

    override func updateConstraints() {
        super.updateConstraints()
        NSLayoutConstraint.activate([
            self.cameraView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.cameraView.topAnchor.constraint(equalTo: self.topAnchor),
            self.cameraView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.cameraView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    override func layout() {
        super.layout()
        self.previewLayer.frame = self.cameraView.frame
    }

    // MARK: - Public Functions

    /// Sets the current InputType
    func setInputType(_ inputType: InputType) {
        self.inputType = inputType
        self.startPreview(inputType: inputType)
    }

    /// Configures the current AVCaptureSession Preset
    func setVideoQuality(_ quality: AVCaptureSession.Preset) {
        self.captureSession.sessionPreset = quality
    }

    /// Mirrors the preview
    func flipPreview(isMirrored: Bool) {
        self.previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
        self.previewLayer.connection?.isVideoMirrored = false
    }

    /// Stops current AVCaptureSession
    func stopPreview() {
        self.captureSession.stopRunning()
    }

    /// Enables a snapshot from the current AVCaptureSession
    func takeSnapshot() {
        self.shouldCaptureSnapshot = true
    }

    /// Attempts to start a new AVCaptureSession if its NOT currently running OR it was chosen to override current session
    func startPreview(overrideCurrentSession: Bool = false, inputType: InputType) {
        if !self.captureSession.isRunning || overrideCurrentSession {

            switch inputType {
                case .camera:
                    guard let cameraInput = cameraInput else {
                        self.delegate?.didEncounterError(CameraError.captureDeviceNotFound)
                        return
                    }
                    self.captureSession.addInput(cameraInput)
                case .screen:
                    guard let screenInput = screenInput else {
                        self.delegate?.didEncounterError(CameraError.captureDeviceNotFound)
                        return
                    }
                    self.captureSession.addInput(screenInput)
            }

                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

                self.flipPreview(isMirrored: isMirrored)

                self.cameraView.layer?.addSublayer(previewLayer)

                self.captureSession.startRunning()
        }
    }
}
