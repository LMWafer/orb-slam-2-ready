#-> Runs the demo
demo:
		while [ true ] ; do \
			cd /dpds/ORB_SLAM2/ && ./Examples/Monocular/mono_tum Vocabulary/ORBvoc.txt Examples/Monocular/TUM1.yaml /app/data/datasets/rgbd_dataset_freiburg1_xyz ; \
			cd /dpds/ORB_SLAM2/ && ./Examples/Monocular/mono_tum Vocabulary/ORBvoc.txt Examples/Monocular/TUM1.yaml /app/data/datasets/rgbd_dataset_freiburg1_rpy ; \
			cd /dpds/ORB_SLAM2/ && ./Examples/Monocular/mono_tum Vocabulary/ORBvoc.txt Examples/Monocular/TUM1.yaml /app/data/datasets/rgbd_dataset_freiburg2_xyz ; \
			cd /dpds/ORB_SLAM2/ && ./Examples/Monocular/mono_tum Vocabulary/ORBvoc.txt Examples/Monocular/TUM1.yaml /app/data/datasets/rgbd_dataset_freiburg2_rpy ; \
		done; 

#-> Downloads and get ready 4 tums datasets to run a demo
prepare:
	apt-get update
	apt-get install -y wget tar
	cd /app/ && \
	rm -rf data/datasets/ && \
	mkdir data/datasets/ && \
	cd data/datasets/ && \
	wget https://vision.in.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_xyz.tgz && \
	wget https://vision.in.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_rpy.tgz && \
	wget https://vision.in.tum.de/rgbd/dataset/freiburg2/rgbd_dataset_freiburg2_xyz.tgz && \
	wget https://vision.in.tum.de/rgbd/dataset/freiburg2/rgbd_dataset_freiburg2_rpy.tgz && \
	tar -xzf rgbd_dataset_freiburg1_xyz.tgz && \
	tar -xzf rgbd_dataset_freiburg1_rpy.tgz && \
	tar -xzf rgbd_dataset_freiburg2_xyz.tgz && \
	tar -xzf rgbd_dataset_freiburg2_rpy.tgz && \
	rm rgbd_dataset_freiburg1_xyz.tgz && \
	rm rgbd_dataset_freiburg1_rpy.tgz && \
	rm rgbd_dataset_freiburg2_xyz.tgz && \
	rm rgbd_dataset_freiburg2_rpy.tgz