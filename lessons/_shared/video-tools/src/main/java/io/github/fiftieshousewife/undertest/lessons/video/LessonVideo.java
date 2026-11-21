package io.github.fiftieshousewife.undertest.lessons.video;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import lombok.extern.slf4j.Slf4j;

/**
 * Entry point for a lesson video's layers, after VHS has recorded {@code <id>.silent.mp4}:
 * <ul>
 *   <li>{@code voice <root> <id> <command...>}: reads each scene's narration aloud with the given command (which turns
 *   a text file into a WAV file), checks each clip fits its scene, and writes {@code <id>.narration.wav};</li>
 *   <li>{@code assemble <root> <id>}: combines the silent video, the narration and the captions into {@code <id>.mp4},
 *   and writes the narration as {@code <id>.narration.m4a} too.</li>
 * </ul>
 * Scene times come from the script and are stretched to the recorded video's real length.
 */
@Slf4j
public final class LessonVideo {

    private LessonVideo() {
    }

    public static void main(final String... args) {
        if (args.length < 3 || !"voice".equals(args[0]) && !"assemble".equals(args[0])) {
            throw new IllegalArgumentException("usage: LessonVideo voice <root> <lesson> <command...>"
                    + " | assemble <root> <lesson>");
        }
        final Media media = new Media(Path.of(args[1]), args[2]);
        if ("voice".equals(args[0])) {
            voice(media, List.of(Arrays.copyOfRange(args, 3, args.length)));
        } else {
            assemble(media);
        }
    }

    static void voice(final Media media, final List<String> command) {
        if (command.isEmpty()) {
            throw new IllegalArgumentException("give the voice command: a program that turns a text file into a WAV");
        }
        final List<Scene> scenes = media.scenes();
        final List<String> narration = Narration.paragraphs(media.file(".narration.md"));
        final Path clipsFolder = media.file(".voice");
        createFolder(clipsFolder);
        final List<WavFile> clips = new ArrayList<>();
        for (int i = 0; i < narration.size(); i++) {
            clips.add(speak(command, narration.get(i), clipsFolder.resolve(String.format("%02d", i + 1))));
        }
        final List<String> misfits = Voiceover.misfits(scenes, clips);
        if (!misfits.isEmpty()) {
            throw new IllegalStateException("The narration does not fit the video:\n  " + String.join("\n  ", misfits));
        }
        Voiceover.track(scenes, clips).write(media.file(".narration.wav"));
        log.info("{}: narration for {} scenes written", media.safeLesson(), clips.size());
    }

    static void assemble(final Media media) {
        final Path folder = media.folder();
        ExternalCommand.run(List.of(ExternalCommand.ffmpeg(), "-y", "-loglevel", "error",
                "-i", media.name(".silent.mp4"), "-i", media.name(".narration.wav"), "-i", media.name(".vtt"),
                "-map", "0:v", "-map", "1:a", "-map", "2:s", "-c:v", "copy", "-c:a", "aac", "-b:a", "128k",
                "-c:s", "mov_text", "-metadata:s:s:0", "language=eng", media.name(".mp4")), folder);
        ExternalCommand.run(List.of(ExternalCommand.ffmpeg(), "-y", "-loglevel", "error",
                "-i", media.name(".narration.wav"), "-c:a", "aac", "-b:a", "128k", media.name(".narration.m4a")),
                folder);
        log.info("{}: finished video written, with voice and captions", media.safeLesson());
    }

    private static WavFile speak(final List<String> command, final String text, final Path clip) {
        final Path textFile = clip.resolveSibling(clip.getFileName() + ".txt");
        final Path wav = clip.resolveSibling(clip.getFileName() + ".wav");
        try {
            Files.writeString(textFile, text);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
        final List<String> full = new ArrayList<>(command);
        full.add(textFile.toAbsolutePath().toString());
        full.add(wav.toAbsolutePath().toString());
        ExternalCommand.run(full, Path.of("").toAbsolutePath());
        return WavFile.read(wav);
    }

    private static void createFolder(final Path folder) {
        try {
            Files.createDirectories(folder);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
