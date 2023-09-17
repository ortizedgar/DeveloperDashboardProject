interface GitHubEvent {
    event_type: string;
    payload: {
        commits: Array<{
            message: string
        }> | undefined
    }
}

interface GitHubEventsData {
    events: Array<GitHubEvent>
}

export type {GitHubEventsData, GitHubEvent}