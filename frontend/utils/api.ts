import axios from 'axios';

const api = axios.create({
    baseURL: `http://${process.env.NEXT_PUBLIC_BACKEND_HOST}/api`
});

const fetchGithubEvents = async () => {
    const {data} = await api.get('/github_events');

    return data;
}

const fetchNews = async () => {
    const {data} = await api.get('/news');

    return data;
};

export {fetchNews, fetchGithubEvents}