package io.github.fiftieshousewife.undertest.lessons.video;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Stream;
import lombok.extern.slf4j.Slf4j;

/**
 * Entry point: {@code Captions <repository root> [lesson id]} writes {@code <id>.vtt} and {@code <id>.srt} next to each
 * lesson's video script, from its narration file. With no lesson id, it does every lesson that has a narration file.
 */
@Slf4j
public final class Captions {

    private Captions() {
    }

    public static void main(final String... args) {
        if (args.length < 1 || args.length > 2) {
            throw new IllegalArgumentException("usage: Captions <repository root> [lesson id]");
        }
        final Path root = Path.of(args[0]);
        final List<String> lessons = args.length == 2 ? List.of(args[1]) : lessonsWithNarration(root);
        lessons.forEach(lesson -> write(root, lesson));
    }

    static void write(final Path root, final String lesson) {
        final Path media = root.resolve("lessons").resolve(lesson).resolve("media");
        final List<Scene> scenes = TapeTimeline.scenes(root, media.resolve(lesson + ".tape"));
        final List<Cue> cues = CaptionFile.cues(scenes, Narration.paragraphs(media.resolve(lesson + ".narration.md")));
        writeFile(media.resolve(lesson + ".vtt"), CaptionFile.webVtt(cues));
        writeFile(media.resolve(lesson + ".srt"), CaptionFile.srt(cues));
        log.info("{}: {} scenes, {} captions, {} seconds", lesson.replace('\r', ' ').replace('\n', ' '), scenes.size(),
                cues.size(),
                Math.round(scenes.getLast().end()));
    }

    static List<String> lessonsWithNarration(final Path root) {
        try (Stream<Path> dirs = Files.list(root.resolve("lessons"))) {
            return dirs.map(dir -> String.valueOf(dir.getFileName()))
                    .filter(id -> Files.isRegularFile(root.resolve("lessons/" + id + "/media/" + id + ".narration.md")))
                    .sorted()
                    .toList();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    private static void writeFile(final Path file, final String text) {
        try {
            Files.writeString(file, text);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
